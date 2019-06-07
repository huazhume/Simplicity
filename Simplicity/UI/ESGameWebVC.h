//
//  ESGameWebVC.h
//  EnjoySplicing
//
//  Created by enjoy on 2019/6/5.
//  Copyright © 2019 EnjoySplicing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESGameWebVC : UIViewController

@property (copy, nonatomic) NSString *url;

@property (assign, nonatomic) BOOL isDismiss;

@property (copy, nonatomic) NSString *titles;

@property (copy, nonatomic) NSString *urlPath;

@end

NS_ASSUME_NONNULL_END
