//
//  SPLaunchVC.m
//  EnjoyGraffiti
//
//  Created by hua on 2020/3/26.
//  Copyright © 2020 hua. All rights reserved.
//

#import "SPLaunchVC.h"
#import "SPWebViewController.h"


@interface SPLaunchVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@end

@implementation SPLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseViews];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initBaseViews
{
    NSString *text =  @"Thank you for usingSimplicity\n\n"
    
    "We have updated the User Agreement in accordance with the latest legal provisions. Please refer to it.\n\n"
    
    "At the same time, in order to provide you with the services you expect, you agree that we will collect, use and share your personal information according to the Privacy Policy. Protecting your privacy is very important to us. We will fully protect your information and enable you to better exercise your personal rights according to the requirements of the applicable law. According to your choice, this software may need to apply for networking, positioning and other permissions in the use process.\n\n"
    "Please read carefully the relevant provisions of the User Agreement and Privacy Policy, especially the exemption or limitation of liability, application of law and dispute resolution clauses. You can click on the above link to read the full text of the Privacy Policy.\n\n";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName: self.textLabel.font}];
    NSDictionary *protocAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                       NSFontAttributeName: self.textLabel.font};
    NSMutableAttributedString *lastAttributedString = [[NSMutableAttributedString alloc] initWithString:@"[Special Tip] When you click Agree, it means that you have fully read, understood and accepted the User Agreement and Privacy Policy.。\n\n\n\n" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName: self.textLabel.font}];
    NSRange range1 = [lastAttributedString.string rangeOfString:@"《User Agreement》"];
    NSRange range2 = [lastAttributedString.string rangeOfString:@"《Privacy policy》"];
    [lastAttributedString setAttributes:protocAttributes range:range1];
    [lastAttributedString setAttributes:protocAttributes range:range2];
    
    [lastAttributedString addAttribute:NSLinkAttributeName
                                 value:@"protocol1://"
                                 range:[[lastAttributedString string] rangeOfString:@"《User Agreement》"]];
    [lastAttributedString addAttribute:NSLinkAttributeName
                                 value:@"protocol2://"
                                 range:[[lastAttributedString string] rangeOfString:@"《Privacy policy》"]];
    
    [attributedString appendAttributedString:lastAttributedString];
    self.textLabel.attributedText = attributedString;
    self.textLabel.delegate = self;

}

- (IBAction)notAgreeButtonClicked:(id)sender
{   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You need to agree to the relevant agreements before you can use this software." delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)agreeButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    NSString *urlString = nil;
    NSString *title = nil;
    if ([[URL scheme] isEqualToString:@"protocol1"]) {
        title = @"User Agreement";
        urlString = @"https://www.jianshu.com/p/ce55ac70b915";
    } else if ([[URL scheme] isEqualToString:@"protocol2"]) {
        title = @"Privacy policy";
        urlString = @"https://www.jianshu.com/p/e07c520ffac0";
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (urlString != nil) {
        
        SPWebViewController *web = [[SPWebViewController alloc] init];
        web.title = title;
        [self.navigationController pushViewController:web animated:YES];
        return YES;
    }
    return YES;
}


- (IBAction)userAction:(id)sender {
    
    NSString *urlString = nil;
    NSString *title = nil;
    title = @"User Agreement";
    urlString = @"UserAgreement.html";
    SPWebViewController *web = [[SPWebViewController alloc] init];
    web.titles  = title;
    web.urlPath = urlString;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)privacyAction:(id)sender {
    NSString *urlString = nil;
    NSString *title = nil;
    title = @"Privacy policy";
    urlString = @"PrivacyPolicy.html";
    SPWebViewController *web = [[SPWebViewController alloc] init];
    web.titles = title;
    web.urlPath = urlString;
    [self.navigationController pushViewController:web animated:YES];
}
@end
