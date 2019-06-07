//
//  ESGameWinVC.m
//  EnjoySplicing
//
//  Created by enjoy on 2019/6/5.
//  Copyright © 2019 EnjoySplicing. All rights reserved.
//

#import "ESGameWinVC.h"

@interface ESGameWinVC ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ESGameWinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image.image = self.cImage;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)popAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yi-xiao-tong-meng-yu-ban/id1397291723?mt=8"];
    UIImage *image = self.image.image;
    NSString *str = @"一款集精美壁纸和好玩小游戏于一体的APP，欢迎下载体验";
    NSArray *activityItems = @[str,image,url];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [SVProgressHUD showSuccessWithStatus:@"shared success"];
        }
    }];
}

- (IBAction)downloadAction:(id)sender {
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.image.size,NO,0.0);
    {
        
        [self.image.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"Save success"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
