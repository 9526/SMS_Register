//
//  LoginViewController.m
//  短信注册
//
//  Created by stefan on 15/11/16.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "LoginViewController.h"

#import "RegisterViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self.view addGestureRecognizer:tap];
    
    [self.password addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneNumber addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    
  
}


- (void)clickTap
{
    [self.phoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)loginBtnClick:(id)sender {
    NSLog(@"登录");
    
}


- (void)textChange
{
    if (self.password.text.length >=6 && self.phoneNumber.text.length >=11 ) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = [UIColor orangeColor];
        NSLog(@"调用了");
    }else
    {
        NSLog(@"不可用");
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = [UIColor redColor];
    }
}

//注册
- (IBAction)registerBtn:(id)sender {
    RegisterViewController *registerControler = [[RegisterViewController alloc] init];
    [self presentViewController:registerControler animated:YES completion:nil];
}




- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}

@end
