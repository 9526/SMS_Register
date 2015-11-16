//
//  RegisterViewController.m
//  短信注册
//
//  Created by stefan on 15/11/16.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *vailNum;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *againPassword;

@property (weak, nonatomic) IBOutlet UIButton *sendVail;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self.view addGestureRecognizer:tap];
    self.password.delegate = self;
    self.againPassword.delegate = self;
}


#pragma -mark 监听return关闭键盘
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"] ) {
        [self.password resignFirstResponder];
        [self.againPassword resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma -mark 点击屏幕关闭键盘
- (void)clickTap
{
    [self.phone resignFirstResponder];
    [self.password resignFirstResponder];
    [self.vailNum resignFirstResponder];
    [self.againPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark 发送验证码倒计时
- (IBAction)sendVailBtn:(id)sender {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证码发送成功");
        }else
        {
            NSLog(@"发送验证码失败");
        }
    }];
    
        __block int timeout = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.sendVail.userInteractionEnabled = YES;
                    [self.sendVail setTitle:@"获取验证码" forState:UIControlStateNormal];
                });
            }else{
                int seconds = timeout % 60;
                __block NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.sendVail.userInteractionEnabled = NO;
                    [self.sendVail setTitle:[NSString stringWithFormat:@"%@s后重发",strTime] forState:UIControlStateNormal];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
}

#pragma -mark 获取验证码后发送注册
- (IBAction)registerBtn:(id)sender {
    
    [SMSSDK commitVerificationCode:self.vailNum.text phoneNumber:self.phone.text zone:@"86" result:^(NSError *error) {
        if(!error)
        {
        NSLog(@"注册成功");
        }else
        {
            NSLog(@"注册失败");
        }
    }];
}


@end
