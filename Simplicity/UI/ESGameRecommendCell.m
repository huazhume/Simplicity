//
//  ESGameRecommendCell.m
//  EnjoyGraffiti
//
//  Created by enjory on 2020/5/1.
//  Copyright © 2020年 hua. All rights reserved.
//

#import "ESGameRecommendCell.h"
#import <UIImageView+AFNetworking.h>

@interface ESGameRecommendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ESGameRecommendCell

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
