//
//  ESStarGameSearcher.h
//  EnjoyGameGame
//
//  Created by JiongXing on 2016/11/15.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "ESGamePathSearch.h"

/// A*搜索的状态(结点)协议
@protocol ESStarGameSearcherStatus <ESGamePathSearchStatus>

/// 从起始状态到当前状态的代价
@property (nonatomic, assign) NSInteger gValue;

/// 从当前状态到目标状态的估算代价
@property (nonatomic, assign) NSInteger hValue;

/// 总代价f = g + h
@property (nonatomic, assign) NSInteger fValue;

/// 估价函数，估算从当前状态到目标状态的代价
- (NSInteger)estimateToTargetStatus:(id<ESGamePathSearchStatus>)targetStatus;

@end




@interface ESStarGameSearcher : ESGamePathSearch

@end