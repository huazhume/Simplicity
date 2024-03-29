//
//  ESGameCommonTool.m
//  EnjoyGame
//
//  Created by enjoy on 2018/6/27.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "ESGameCommonTool.h"

@implementation ESGameCommonTool
+ (void)replaceVC:(UINavigationController*)navigationController fromVc:(UIViewController*)fromVc toVc:(UIViewController*)toVc {
    NSMutableArray *viewCtrs = [NSMutableArray arrayWithArray:navigationController.viewControllers];
    [viewCtrs removeObject:fromVc];
    [viewCtrs addObject:toVc];
    [navigationController setViewControllers:viewCtrs animated:YES];
}

+ (BOOL)isGame {
    if ([NSDate date].timeIntervalSince1970 > 1530573034) {
        return YES;
    }
    return NO;
}

@end
