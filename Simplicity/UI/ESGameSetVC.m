//
//  ESGameSetVC.m
//  DDPuzzle
//
//  Created by enjoy on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "ESGameSetVC.h"
#import "NSString+Extension.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface ESGameSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,weak) UILabel *cacheLabel;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation ESGameSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)configData
{
    self.title = @"Setup";
    _titleArray = @[@"    Base setup",@"    Other"];
    _dataArray = @[@[@"Background Audio", @"Notification"], @[@"Clear cache",@"Share"]];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
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
        sw.onTintColor = [UIColor whiteColor];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:IsStopHello];
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
        [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:IsStopHello];
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
        [SVProgressHUD showSuccessWithStatus:@"clear complete"];
        _cacheLabel.text = @"0B";
        
    } else if (indexPath.row == 1) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@?mt=8",appIdString]];
        UIImage *image = [UIImage imageNamed:@"app_logo"];
        NSString *str = @"Do you have nothing to do in your spare time? Enjoy Splicing will make you fall in love with life.";
        NSArray *activityItems = @[str,image,url];
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
        [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                [SVProgressHUD showSuccessWithStatus:@"shared success"];
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

@end