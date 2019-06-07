//
//  EnterController.m
//  EnjoyGame
//
//  Created by enjoy on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "ESGameHomeVC.h"
#import "ESPuzzleGameStatus.h"
#import "ESBreadthGameSearcher.h"
#import "ESDoubleGameSearcher.h"
#import "ESStarGameSearcher.h"
#import "ESGameWaveButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "ESGameWinVC.h"

@interface ESGameHomeVC()<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 矩阵阶数
@property (nonatomic, assign) NSInteger matrixOrder;
/// 当前算法。1：广搜； 2：双向广搜； 3：A*算法
@property (nonatomic, assign) NSInteger algorithm;

#pragma mark - 状态
/// 当前游戏状态
@property (nonatomic, strong) ESPuzzleGameStatus *gameCurrentStatus;
/// 完成时的游戏状态
@property (nonatomic, strong) ESPuzzleGameStatus *didStatus;
/// 保存的游戏状态
@property (nonatomic, strong) ESPuzzleGameStatus *endStatus;
@property (weak, nonatomic) IBOutlet ESGameWaveButton *quitButton;

/// 标记正在自动拼图
@property (nonatomic, assign) BOOL isAutoing;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *autotimer;
@property (nonatomic,assign) NSInteger mytimeCount;
@property (nonatomic,assign) NSInteger gainScorenumbers;

@property (weak, nonatomic) IBOutlet ESGameWaveButton *resetBtn;
@property (weak, nonatomic) IBOutlet ESGameWaveButton *autoBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic,strong) AVAudioPlayer *gameSosoPlayer;
@property (nonatomic,strong) AVAudioPlayer *gamemoveSosoPlayer;
@property (nonatomic,strong) AVAudioPlayer *backgroundPlayer;
@property (nonatomic,strong) AVAudioPlayer *goodbyePlayer;
@property (nonatomic,strong) AVAudioPlayer *winSuccessPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (nonatomic,assign) dispatch_semaphore_t sema;
@end

@implementation ESGameHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
}

- (void)configData
{
    self.previewImage.layer.masksToBounds = YES;
    //    self.iconImage = [UIImage imageNamed:@"source"];
    //    self.originImage = [UIImage imageNamed:@"source"];
    _downloadBtn.hidden = YES;
    self.matrixOrder = 3;
    self.algorithm = 3;
    _previewImage.image = _iconImage;
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    self.image = self.iconImage;
    [self randomPiece];
    
    _resetBtn.layer.cornerRadius = 20;
    _resetBtn.clipsToBounds = YES;
    
    _autoBtn.layer.cornerRadius = 20;
    _autoBtn.clipsToBounds = YES;
    
    _quitButton.layer.cornerRadius = 20;
    _quitButton.layer.masksToBounds = YES;
    
    if (isAudio) {
        [self initPlayer];
    }
    if (kScreenWidth == 320) {
        _scrollView.contentSize = CGSizeMake(0, 600);
        _scrollView.contentSize = CGSizeMake(0, _viewHeightConstraint.constant);
    } else {
        _viewHeightConstraint.constant = kScreenHeight - kSafeAreaBottom - kStatusHeight;
        _scrollView.contentSize = CGSizeMake(0, _viewHeightConstraint.constant);
    }
    _scrollView.bounces = NO;
}

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)downloadClicked:(UIButton *)sender {
    //你赢了 ？
    ESGameWinVC *vc = [ESGameWinVC new];
    vc.cImage = self.originImage;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)initPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gamecenter" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _backgroundPlayer.numberOfLoops = -1;
    _backgroundPlayer.delegate = self;
    [_backgroundPlayer prepareToPlay];
    [_backgroundPlayer play];
}

- (void)beginGame {
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    _autotimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:self repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_autotimer forMode:NSDefaultRunLoopMode];
}

- (void)updateTimer {
    self.mytimeCount += 1;
}

- (void)setMytimeCount:(NSInteger)timeCount {
    _mytimeCount = timeCount;
    if (timeCount > 99*60) {
        [self onResetButton:nil];
        return;
    }
    NSInteger minute = timeCount/60;
    NSInteger second = timeCount%60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeLabel.text = timeStr;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self enterAnimation];
    
    if (_backgroundPlayer) {
        [_backgroundPlayer play];
    }
}

- (void)enterAnimation {
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.84, 0.84);
    self.view.center = [UIApplication sharedApplication].keyWindow.center;
    [UIView animateWithDuration:0.36 animations:^{
        self.view.alpha = 1.f;
        self.view.transform = CGAffineTransformIdentity;
        self.view.center = [UIApplication sharedApplication].keyWindow.center;
    }];
}

- (void)randomPiece {
    ESPuzzleGameStatus *status = self.gameCurrentStatus;
    NSInteger pieceIndex = arc4random() % 9;
    
    ESPuzzleGamePiece *piece = [status.pieceArray objectAtIndex:pieceIndex];
    
    // 挖空一格
    if (status.emptyIndex < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0;
        }];
        status.emptyIndex = pieceIndex;
        self.didStatus = [self.gameCurrentStatus  copyStatus];
    }
    
    __weak typeof(self) ws = self;
    [self gameOnShuAction:^{
        self.mytimeCount = 0;
        [ws beginGame];
    }];
}

/// 点击方块
- (void)onPieceTouch:(ESPuzzleGamePiece *)piece {
    if (self.isAutoing) {
        return;
    }
    
    if (_gamemoveSosoPlayer) {
        if ([_gamemoveSosoPlayer isPlaying]) {
            [_gamemoveSosoPlayer stop];
        }
        _gamemoveSosoPlayer = nil;
    }
    
    ESPuzzleGameStatus *status = self.gameCurrentStatus;
    NSInteger pieceIndex = [status.pieceArray indexOfObject:piece];
    
    // 挖空一格
    if (status.emptyIndex < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0;
        }];
        status.emptyIndex = pieceIndex;
        self.didStatus = [self.gameCurrentStatus  copyStatus];
        return;
    }
    
    if (![status canMoveToIndex:pieceIndex]) {
        NSLog(@"无法移动，target index:%@",  @(pieceIndex));
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"movepiece" ofType:@"mp3"];
    NSInteger index = arc4random()%5;
    if (index == 0) {
        NSInteger rand = arc4random()%4;
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sound_%ld",rand] ofType:@"mp3"];
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    _gamemoveSosoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _gamemoveSosoPlayer.delegate = self;
    [_gamemoveSosoPlayer prepareToPlay];
    [_gamemoveSosoPlayer play];
    
    [status moveToIndex:pieceIndex];
    [self reloadWithStatus:self.gameCurrentStatus];
    
    if ([status equalWithStatus:self.didStatus]) {
        [self esgameToEnd];
    }
}

- (void)showgameCurrentStatusOnView:(UIView *)view {
    CGFloat size = kScreenWidth*0.9 / self.matrixOrder;
    NSInteger index = 0;
    for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
        for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
            ESPuzzleGamePiece *piece = self.gameCurrentStatus.pieceArray[index ++];
            piece.frame = CGRectMake(col * size, row * size, size, size);
            [view addSubview:piece];
        }
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self onResetButton:nil];
}

- (void)reloadWithStatus:(ESPuzzleGameStatus *)status {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize size = status.pieceArray.firstObject.frame.size;
        NSInteger index = 0;
        for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
            for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
                ESPuzzleGamePiece *piece = status.pieceArray[index ++];
                piece.frame = CGRectMake(col * size.width, row * size.height, size.width, size.height);
            }
        }
    }];
}

- (void)setMatrixOrder:(NSInteger)matrixOrder {
    _matrixOrder = matrixOrder;
    [self onResetButton:nil];
}

- (void)gameOnShuAction:(void (^)())complete{
    if (self.isAutoing) {
        return;
    }
    if (self.gameCurrentStatus.emptyIndex < 0) {
        return;
    }
    
    NSLog(@"打乱顺序：当前为%@阶方阵, 随机移动%@步", @(self.matrixOrder), @(self.matrixOrder * self.matrixOrder * 10));
    [self.gameCurrentStatus shuffleCount:self.matrixOrder * self.matrixOrder * 10];
    [self reloadWithStatus:self.gameCurrentStatus];
    if (complete) {
        complete();
    }
}

- (IBAction)onResetButton:(UIButton *)sender {
    if (self.isAutoing) {
        return;
    }
    if (!self.image) {
        return;
    }
    
    if (_gameSosoPlayer) {
        if ([_gameSosoPlayer isPlaying]) {
            [_gameSosoPlayer stop];
        }
        _gameSosoPlayer = nil;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"soso" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _gameSosoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _gameSosoPlayer.delegate = self;
    [_gameSosoPlayer prepareToPlay];
    [_gameSosoPlayer play];
    
    _autoBtn.enabled = YES;
    [_autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.gameCurrentStatus) {
        [self.gameCurrentStatus removeAllPieces];
    }
    self.gameCurrentStatus = [ESPuzzleGameStatus statusWithMatrixOrder:self.matrixOrder image:self.image];
    [self.gameCurrentStatus.pieceArray enumerateObjectsUsingBlock:^(ESPuzzleGamePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
        [obj addTarget:self action:@selector(onPieceTouch:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.didStatus = nil;
    [self showgameCurrentStatusOnView:self.bgView];
    [self randomPiece];
}

#pragma mark 自动
- (IBAction)onAutoButton:(UIButton *)sender {
    if (self.isAutoing) {
        return;
    }
    if (self.gameCurrentStatus.emptyIndex < 0) {
        return;
    }
    sender.enabled = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsVIP]) {
        [self esgameAutoMove];
        return;
    }
    //点击自动完成的时候先将计时器静止
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.autoBtn.enabled = NO;
        [self.autoBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        self.resetBtn.enabled = NO;
        [self.resetBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        [self esgameAutoMove];
    });
    
    [SVProgressHUD dismiss];
    _autoBtn.enabled = YES;
    NSLog(@"购买成功");
    
}

- (void)esgamesetisAutoing:(BOOL)isAutoing {
    _isAutoing = isAutoing;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isAutoing) {
            self.resetBtn.enabled = NO;
        } else {
            self.resetBtn.enabled = YES;
        }
    });
}

- (void)esgameToEnd {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _winSuccessPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _winSuccessPlayer.delegate = self;
    [_winSuccessPlayer prepareToPlay];
    [_winSuccessPlayer play];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.autoBtn.enabled = NO;
        [self.autoBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        self.resetBtn.enabled = YES;
        [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.gameCurrentStatus.pieceArray enumerateObjectsUsingBlock:^(ESPuzzleGamePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.enabled = NO;
        }];
        
        self.downloadBtn.hidden = NO;
        
        //你赢了   self.originImage
        ESGameWinVC *vc = [ESGameWinVC new];
        vc.cImage = self.originImage;
        [self.navigationController pushViewController:vc animated:YES];
    
    });
    
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    if (self.completeGameBlock) {
        self.completeGameBlock();
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"保存失败"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    if (self.beingDismissed) {
        [_backgroundPlayer stop];
        _backgroundPlayer = nil;
    } else {
        [_backgroundPlayer pause];
    }
    
    [SVProgressHUD dismiss];
}

#pragma mark --------YQInAppPurchaseToolDelegate
- (void)esgameAutoMove {
    ESGamePathSearch *searcher = nil;
    switch (self.algorithm) {
        case 1:
            NSLog(@"----- 广度优先搜索 -----");
            searcher = [[ESBreadthGameSearcher alloc] init];
            break;
        case 2:
            NSLog(@"----- 双向广度优先搜索 -----");
            searcher = [[ESDoubleGameSearcher alloc] init];
            break;
        case 3:
            NSLog(@"----- A*搜索 -----");
            searcher = [[ESStarGameSearcher alloc] init];
            break;
        default:
            break;
    }
    searcher.startStatus = [self.gameCurrentStatus copyStatus];
    searcher.targetStatus = [self.didStatus copyStatus];
    [searcher setEqualComparator:^BOOL(ESPuzzleGameStatus *status1, ESPuzzleGameStatus *status2) {
        return [status1 equalWithStatus:status2];
    }];
    // 开始搜索
    NSMutableArray<ESPuzzleGameStatus *> *path = [searcher search];
    __block NSInteger pathCount = path.count;
    NSLog(@"需要移动：%@步", @(pathCount));
    
    if (!path || pathCount == 0) {
        return;
    }
    
    // 开始自动拼图
    self.isAutoing = YES;
    [self beginGame];
    
    // 定时信号，控制拼图速度
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    _sema = sema;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateGameSemes) userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [path enumerateObjectsUsingBlock:^(ESPuzzleGameStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 等待信号
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            // 刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // 显示排列
                [self reloadWithStatus:obj];
            });
        }];
        
        // 拼图完成
        [self.timer invalidate];
        [self esgameToEnd];
        self.gameCurrentStatus = [path lastObject];
        self.isAutoing = NO;
    });
}

- (void)updateGameSemes {
    dispatch_semaphore_signal(_sema);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _goodbyePlayer) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    player = nil;
}

- (void)dealloc {
    NSLog(@"=========");
}

@end

