//
//  ViewController.m
//  Simplicity
//
//  Created by xiaobai zhang on 2019/5/29.
//  Copyright © 2019 Simplicity. All rights reserved.
//

#import "ViewController.h"
#import "GameCenterController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startGame:(id)sender {
    
    GameCenterController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameCenterController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
