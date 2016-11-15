//
//  LoginVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "LoginVC.h"
#import "Defines.h"

@interface LoginVC () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *userField;
@property (nonatomic, weak) UITextField *passField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"登录";
    
    // 用户输入背景
    UIView *inputBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width - 30, 108)];
    inputBGView.cornerRadius = 8;
    [self.contentView addSubview:inputBGView];
    inputBGView.backgroundColor = [UIColor whiteColor];
    
    inputBGView.layer.borderColor = [IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR CGColor];
    inputBGView.layer.borderWidth = 0.5;//( 1.0 / [[UIScreen mainScreen] scale] ) / 2;
    
    inputBGView.clipsToBounds = YES;
    
    inputBGView.center = CGPointMake(self.contentView.width / 2, 20 + inputBGView.height / 2);
    
    // 手机
    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, inputBGView.width - 20, 34)];
    [inputBGView addSubview:userField];
    userField.placeholder = @"手机号";
    userField.keyboardType = UIKeyboardTypeNumberPad;
    
    userField.delegate = self;
    
    self.userField = userField;
    
    UIImageView *iconView = AWCreateImageView(@"icon_user.png");
    [inputBGView addSubview:iconView];
    iconView.center = CGPointMake(10 + iconView.width / 2, userField.midY);
    
    userField.left = iconView.right + 10;
    userField.width -= iconView.width - 10;
    
    UIView *hairLine = [AWHairlineView horizontalLineWithWidth:inputBGView.width
                                                         color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
                                                        inView:inputBGView];
    hairLine.center = CGPointMake(hairLine.width / 2, inputBGView.height / 2);
    
    // 密码
    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(10, 54 + 10, inputBGView.width - 20, 34)];
    [inputBGView addSubview:passField];
    passField.placeholder = @"密码";
    passField.secureTextEntry = YES;
    
    iconView = AWCreateImageView(@"icon_password.png");
    [inputBGView addSubview:iconView];
    iconView.center = CGPointMake(10 + iconView.width / 2, passField.midY);
    
    passField.left = userField.left;
    passField.width = userField.width;
    
    passField.returnKeyType = UIReturnKeyDone;
    
    passField.delegate = self;
    
    self.passField = passField;
    
    // 忘记密码
    UIButton *forgetBtn = AWCreateTextButton(CGRectMake(0, 0, 88, 37),
                                             @"忘记密码?",
                                             NAV_BAR_BG_COLOR,
                                             self,
                                             @selector(forgetPassword));
    [self.contentView addSubview:forgetBtn];
    forgetBtn.position = CGPointMake(inputBGView.right - forgetBtn.width,
                                     inputBGView.bottom + 5);

    // 注册按钮
    CGFloat buttonWidth = ( self.contentView.width - 15 * 2 - 20 ) / 2;
    AWButton *signupButton = [AWButton buttonWithTitle:@"注册" color:NAV_BAR_BG_COLOR];
    [self.contentView addSubview:signupButton];
    signupButton.frame = CGRectMake(15, forgetBtn.bottom + 20, buttonWidth, 50);
    signupButton.outline = YES;
    signupButton.cornerRadius = 4;
    
    [signupButton addTarget:self forAction:@selector(gotoSignup)];
    
    // 登录按钮
    AWButton *loginButton = [AWButton buttonWithTitle:@"登录" color:NAV_BAR_BG_COLOR];
    [self.contentView addSubview:loginButton];
    loginButton.frame = signupButton.frame;
    loginButton.left = self.contentView.width - loginButton.width - signupButton.left;
    loginButton.cornerRadius = signupButton.cornerRadius;
    
    [loginButton addTarget:self forAction:@selector(doLogin)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self doLogin];
    
    return YES;
}

- (void)forgetPassword
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"MobileInputVC" params:@{ @"title": @"忘记密码" }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSignup
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"MobileInputVC" params:@{ @"title": @"注册" }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doLogin
{
    if ( [self.userField.text trim].length == 0 ) {
        [self.contentView makeToast:@"手机号不能为空"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    NSString* reg = @"^1[3|4|5|7|8][0-9]\\d{4,8}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ( ![predicate evaluateWithObject:self.userField.text] ) {
        [self.contentView makeToast:@"手机号不正确"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    if ( [self.passField.text trim].length == 0 ) {
        [self.contentView makeToast:@"密码不能为空"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [[UserService sharedInstance] loginWithMobile:self.userField.text
                                         password:self.passField.text
                                       completion:^(User *aUser, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
        if ( !error ) {
            [self.contentView makeToast:@"登录成功"
                               duration:2.0
                               position:CSToastPositionTop];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.contentView makeToast:error.domain
                               duration:2.0
                               position:CSToastPositionTop];
        }
    }];
}

@end
