//
//  ESGameWebVC.m
//  EnjoySplicing
//
//  Created by enjoy on 2019/6/5.
//  Copyright © 2019 EnjoySplicing. All rights reserved.
//

#import "ESGameWebVC.h"

@interface ESGameWebVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ESGameWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.navigationController.navigationBarHidden = !self.titles.length;
    self.title = self.titles;
    
    
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.opaque = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.title = self.titles;
    if (self.urlPath) {
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.urlPath ofType:nil]]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if ([url hasPrefix:@"itms"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    return YES;
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
