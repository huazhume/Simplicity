//
//  FLPaintingItemCell.m
//  EnjoyGraffiti
//
//  Created by hua on 2020/5/1.
//  Copyright © 2020年 hua. All rights reserved.
//

#import "FLPaintingItemCell.h"
#import <UIImageView+AFNetworking.h>

@interface FLPaintingItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FLPaintingItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

- (void)setWebUrl:(NSString *)webUrl
{
    _webUrl = webUrl;
    self.imageView.image = [UIImage imageNamed:webUrl];
}

@end
