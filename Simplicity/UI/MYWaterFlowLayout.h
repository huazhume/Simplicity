//
//  WaterFlowLayout.h
//  Meiyu
//
//  Created by xiaobai zhang on 2017/12/16.
//  Copyright © 2017年 jimeiyibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYWaterFlowLayout;

@protocol MYWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(MYWaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(MYWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(MYWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(MYWaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(MYWaterFlowLayout *)waterflowLayout;

@end
@interface MYWaterFlowLayout : UICollectionViewLayout
@property (nonatomic ,weak) id <MYWaterFlowLayoutDelegate> delegate;
@end
