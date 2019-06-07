//
//  ESGamePathSearch.m
//  EnjoyGameGame
//
//  Created by JiongXing on 2016/11/13.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "ESGamePathSearch.h"

@implementation ESGamePathSearch

- (NSMutableArray *)search {
    if (!self.startStatus || !self.targetStatus || !self.equalComparator) {
        return nil;
    }
    return [NSMutableArray array];
}

- (NSMutableArray *)constructPathWithStatus:(id<ESGamePathSearchStatus>)status isLast:(BOOL)isLast {
    NSMutableArray *path = [NSMutableArray array];
    if (!status) {
        return path;
    }
    
    do {
        if (isLast) {
            [path insertObject:status atIndex:0];
        }
        else {
            [path addObject:status];
        }
        status = [status parentStatus];
    } while (status);
    return path;
}

- (void)setStartStatus:(id<ESGamePathSearchStatus>)startStatus {
    // 保证开始状态是没有父状态的。为了保证在构建路径的时候不会超出开始状态。
    [startStatus setParentStatus:nil];
    _startStatus = startStatus;
}

- (void)setTargetStatus:(id<ESGamePathSearchStatus>)targetStatus {
    // 保证目标状态是没有父状态的。为了保证在构建路径的时候不会超出目标状态。
    [targetStatus setParentStatus:nil];
    _targetStatus = targetStatus;
}

@end
