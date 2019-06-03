//
//  SetController.m
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "SetController.h"
#import "NSString+Extension.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface SetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,weak) UILabel *cacheLabel;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    _titleArray = @[@"    动画音效",@"    其他"];
    _dataArray = @[@[@"欢迎问候语",@"动画效果"],@[@"清除缓存",@"分享"]];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSArray *array = _dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = array[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = indexPath.row;
        sw.onTintColor = [UIColor blackColor];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            sw.on = ![[NSUserDefaults standardUserDefaults] boolForKey:IsStopHello];
        } else {
            sw.on = ![[NSUserDefaults standardUserDefaults] boolForKey:IsStopAnimate];
        }
        cell.accessoryView = sw;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titleArray[section];
}

- (void)switchAction:(UISwitch *)sw {
    sw.on = !sw.on;
    if (sw.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:!sw.isOn forKey:IsStopHello];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:!sw.isOn forKey:IsStopAnimate];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.row == 0) {
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:CachePath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [CachePath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [SVProgressHUD showSuccessWithStatus:@"清除完成"];
        _cacheLabel.text = @"0B";
    } else if (indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yi-xiao-tong-meng-yu-ban/id1397291723?mt=8"];
        UIImage *image = [UIImage imageNamed:@"shareLogo"];
        NSString *str = @"一款集精美壁纸和好玩小游戏于一体的APP，欢迎下载体验";
        NSArray *activityItems = @[str,image,url];
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
        [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            }
        }];
    } else {

    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusHeight + 20, kScreenWidth, kScreenHeight - kStatusHeight - 44 - kSafeAreaBottom) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (void)configBgView {
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_bgView];
}


@end
