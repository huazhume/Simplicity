//
//  ESGameRecommendVC.m
//  EnjoySplicing
//
//  Created by enjoy on 2019/6/4.
//  Copyright © 2019 EnjoySplicing. All rights reserved.
//

#import "ESGameRecommendVC.h"
#import "ESGameFlowLayout.h"
#import "ESGameReContentCell.h"
#import <UIImageView+WebCache.h>
#import <RSKImageCropViewController.h>
#import "ESGameHomeVC.h"

@interface ESGameRecommendVC ()
<UICollectionViewDataSource,
ESGameFlowLayoutDelegate,
UICollectionViewDelegate,
RSKImageCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *datalist;
@property (nonatomic,weak) RSKImageCropViewController *imageCropVC;

@end

@implementation ESGameRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Recommend";
    ESGameFlowLayout *layout = [[ESGameFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    layout.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ESGameReContentCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ESGameReContentCell"];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    NSArray *images = @[@"http://f2.313515.com/e7f40f03cf0e4e3bad00c273761d4dcf.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/fb77fc9fac3e4ce7bcfae7f08755fd4a.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/65b5d93a1ce8441da648c9122af71280.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/5b4d812a8ece4595b0f354098d6ffeeb.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/baa0fd9f580a4791bb8a015a4f039b04.JPG?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/3931ad5917fc4d6d88d7ebeb19c05247.JPG?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/07cc163fbcb743e18e1e8685bee8322e.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/c602e93f078644199099904f8ef49808.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/7b219eba680c4fa7b27fa06019096364.JPG?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/41e129006ee54305aec3fb0d87ae1e01.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/2e6640e94d3146bca26bffdc03e6db8f.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/cfa6592a14c946b69068e5470625c37e.JPG?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/f8e5ce0637594e708efc1f0970a78ee3.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/fa3d7c4b59c84428bf7aa54845456406.JPG?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/4658d8e2784f4536b637f3400e14c8d5.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/d757e65977a94c2daa4a8ab1f84e14db.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/287518a6a32649e7b3ddde0aea8c0be7.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/e3a30690b3bc4889a910da1aaedc11ff.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/f216995301594190bde61834d71f0966.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/9a6f761277194da3a96fd363c35a575c.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/0db3fe05bc244aa48836919c64b46680.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/364bea1e6be84f978b846f0564f4bd5b.jpg?imageMogr2/thumbnail/300x",
       @"http://f2.313515.com/12b96255205b4a39a6e8c6f9fb0830dc.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/4ecf7c1146484976978ffc03fd39b7b2.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/a73fa8e17f734484a8af9ed3a2684074.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/abe4fa5bb3a14b1da4e428a70790e6e8.jpg?imageMogr2/thumbnail/300x",
      @"http://f2.313515.com/513b987c5fb146f193cf8e603ccaa8ed.jpg?imageMogr2/thumbnail/300x"];
    
    self.datalist = [images copy];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - collectionView delegate * dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESGameReContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESGameReContentCell" forIndexPath:indexPath];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:self.datalist[indexPath.row]]];
    
    return cell;
}

- (CGFloat)waterFlowLayout:(ESGameFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
   
    return 100 + arc4random_uniform(100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    ESGameReContentCell *cell = (ESGameReContentCell *)[collectionView cellForItemAtIndexPath:indexPath];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:cell.image.image cropMode:RSKImageCropModeSquare];
    imageCropVC = imageCropVC;
    imageCropVC.delegate = self;
    self.imageCropVC = imageCropVC;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

#pragma mark - RSKImageCropViewControllerDataSource
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    ESGameHomeVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ESGameHomeVC"];
    
    NSMutableArray *viewCtrs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewCtrs removeObject:self.imageCropVC];
    [self.navigationController setViewControllers:viewCtrs animated:NO];
    vc.iconImage = croppedImage;
    vc.originImage = croppedImage;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imageCropViewControllerDidCancelCrop:(nonnull RSKImageCropViewController *)controller {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setter & Getter

- (NSArray *)datalist
{
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}


@end
