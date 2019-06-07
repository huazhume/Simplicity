//
//  WaterFlowLayout.h
//  Meiyu
//
//  Created by enjoy on 2017/12/16.
//  Copyright © 2017年 jimeiyibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESGameFlowLayout;

@protocol ESGameFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(ESGameFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(ESGameFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(ESGameFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(ESGameFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(ESGameFlowLayout *)waterflowLayout;

@end
@interface ESGameFlowLayout : UICollectionViewLayout
@property (nonatomic ,weak) id <ESGameFlowLayoutDelegate> delegate;
@end
