//
//  ESGameCommonTool.h
//  EnjoyGame
//
//  Created by enjoy on 2018/6/27.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESGameCommonTool : NSObject
+ (void)replaceVC:(UINavigationController*)navigationController fromVc:(UIViewController*)fromVc toVc:(UIViewController*)toVc;
+ (BOOL)isGame;
@end
