//
//  PasswordVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "PasswordVC.h"
#import "Defines.h"

@interface PasswordVC () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *password1Field;
@property (nonatomic, weak) UITextField *password2Field;

@end

@implementation PasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"设置密码";
    
    // 用户输入背景
    UIView *inputBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width - 30, 108)];
    inputBGView.cornerRadius = 8;
    [self.contentView addSubview:inputBGView];
    inputBGView.backgroundColor = [UIColor whiteColor];
    
    inputBGView.layer.borderColor = [IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR CGColor];
    inputBGView.layer.borderWidth = 0.5;//( 1.0 / [[UIScreen mainScreen] scale] ) / 2;
    
    inputBGView.clipsToBounds = YES;
    
    inputBGView.center = CGPointMake(self.contentView.width / 2, 20 + inputBGView.height / 2);
    
    // 密码
    UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, inputBGView.width - 20, 34)];
    [inputBGView addSubview:userField];
    userField.placeholder = @"输入密码";
    userField.secureTextEntry = YES;
    userField.delegate = self;
    
    self.password1Field = userField;
    
    UIView *hairLine = [AWHairlineView horizontalLineWithWidth:inputBGView.width
                                                         color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
                                                        inView:inputBGView];
    hairLine.center = CGPointMake(hairLine.width / 2, inputBGView.height / 2);
    
    // 确认密码
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 54 + 10, inputBGView.width - 20, 34)];
    [inputBGView addSubview:codeField];
    codeField.placeholder = @"确认密码";
    codeField.returnKeyType = UIReturnKeyDone;
    codeField.secureTextEntry = YES;
    codeField.delegate = self;
    
    self.password2Field = codeField;
    
    // 确定按钮
    AWButton *okButton = [AWButton buttonWithTitle:@"完成" color:NAV_BAR_BG_COLOR];
    [self.contentView addSubview:okButton];
    okButton.frame = CGRectMake(15, inputBGView.bottom  + 15, inputBGView.width, 50);
    [okButton addTarget:self forAction:@selector(done)];

}

- (void)back
{
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ( [NSStringFromClass([vc class]) isEqualToString:@"LoginVC"] ) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)done
{
    if ( [self.password1Field.text trim].length == 0 ) {
        [self.contentView makeToast:@"密码不能为空"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    if ( [self.password2Field.text trim].length == 0 ) {
        [self.contentView makeToast:@"确认密码不能为空"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    if ( self.password1Field.text.length < 6 ) {
        [self.contentView makeToast:@"密码至少为6位"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    if ( [self.password2Field.text isEqualToString:self.password1Field.text] == NO ) {
        [self.contentView makeToast:@"两次密码输入不一致"
                           duration:2.0
                           position:CSToastPositionTop];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    __weak typeof(self) me = self;
    [self.dataService POST:ADD_USER_INFO params:@{ @"tel": self.params[@"mobile"] ?: @"",
                                                   @"pwd": self.password1Field.text
                                                   }
                completion:^(id result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:me.contentView animated:YES];
        
        if ( !error ) {
            if ( [me.params[@"from"] isEqualToString:@"forget"] ) {
                [me.contentView makeToast:@"密码设置成功" duration:2.0 position:CSToastPositionTop];
                [me back];
            } else {
                [me.contentView makeToast:@"用户注册成功" duration:2.0 position:CSToastPositionTop];
                [[UserService sharedInstance] saveUser:[[User alloc] initWithDictionary:result]];
                [me.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            [me.contentView makeToast:error.domain duration:2.0 position:CSToastPositionTop];
        }
    }];
}

@end
