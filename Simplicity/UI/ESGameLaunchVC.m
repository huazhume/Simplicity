//
//  ESGameLaunchVC.m
//  EnjoyGraffiti
//
//  Created by enjory on 2020/3/26.
//  Copyright © 2020 hua. All rights reserved.
//

#import "ESGameLaunchVC.h"
#import "ESGameWebVC.h"


@interface ESGameLaunchVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@end

@implementation ESGameLaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseViews];
    self.navigationController.navigationBarHidden = YES;
}


- (void)configBaseViews
{
    NSString *text =  @"Thank you for usingEnjoySplicing\n\n"
    
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
    
    NSString *key = @"pofsdfgihsdgj";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)userAction:(id)sender {
    
    NSString *urlString = nil;
    NSString *title = nil;
    title = @"User Agreement";
    urlString = @"UserAgreement.html";
    ESGameWebVC *web = [[ESGameWebVC alloc] init];
    web.titles  = title;
    web.urlPath = urlString;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)privacyAction:(id)sender {
    NSString *urlString = nil;
    NSString *title = nil;
    title = @"PrivacyPolicy";
    urlString = @"PrivacyPolicy.html";
    ESGameWebVC *web = [[ESGameWebVC alloc] init];
    web.titles = title;
    web.urlPath = urlString;
    [self.navigationController pushViewController:web animated:YES];
}


@end
