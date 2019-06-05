//
//  ViewController.m
//  Simplicity
//
//  Created by xiaobai zhang on 2019/5/29.
//  Copyright © 2019 Simplicity. All rights reserved.
//

#import "ViewController.h"
#import "SPGameVC.h"
#import "SetController.h"
#import "SPRecommendController.h"
#import <RSKImageCropViewController.h>
#import "SPLaunchVC.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController pushViewController:[SPLaunchVC new] animated:NO];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startGame:(id)sender {
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose from album",@"Take a photo",@"Recommond photos",nil];
    [actionSheet showInView:self.view];
    
}
- (IBAction)setting:(id)sender {
    
    SetController *vc = [SetController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma marj - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"_______________%ld",buttonIndex);
    if (buttonIndex == 0) {
        [self LocalPhoto];
    } else if (buttonIndex == 1) {
        [self takePhoto];
    } else if (buttonIndex == 2) {
        SPRecommendController *vc = [SPRecommendController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - photo
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"无法打开照相机");
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{ UIImage *sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:sourceImage cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    imageCropVC.avoidEmptySpaceAroundImage = YES;
    [picker pushViewController:imageCropVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor blackColor];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - RSKImageCropViewControllerDataSource
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    
    [controller dismissViewControllerAnimated:NO completion:^{
            SPGameVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SPGameVC"];
            vc.iconImage = croppedImage;
            vc.originImage = croppedImage;
            [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)imageCropViewControllerDidCancelCrop:(nonnull RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
