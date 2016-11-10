//
//  UpdateNicknameVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "UpdateNicknameVC.h"
#import "Defines.h"

@interface UpdateNicknameVC ()

@property (nonatomic, weak) UITextField *nicknameField;

@end

@implementation UpdateNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"设置昵称";
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    AWTextField *textField = [[AWTextField alloc] initWithFrame:CGRectMake(15, 15,
                                                                           self.contentView.width - 30,
                                                                           37)];
    [self.contentView addSubview:textField];
    self.nicknameField = textField;
    
    textField.text = [[[UserService sharedInstance] currentUser] name] ?:
                     [[[UserService sharedInstance] currentUser] mobile];
    
    AWButton *saveBtn = [AWButton buttonWithTitle:@"保存" color:NAV_BAR_BG_COLOR];
    saveBtn.frame = textField.frame;
    saveBtn.height = 44;
    saveBtn.top = textField.bottom + 20;
    
    [self.contentView addSubview:saveBtn];
    
    [saveBtn addTarget:self forAction:@selector(save)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)save
{
    if ( self.nicknameField.text.trim.length == 0 ) {
        [self.contentView makeToast:@"昵称不能为空" duration:2.0 position:CSToastPositionTop];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    [[UserService sharedInstance] updateUserProfile:@{ @"key": @"username", @"value": self.nicknameField.text } completion:^(User *aUser, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
        if ( error ) {
            [self.contentView makeToast:@"昵称设置失败" duration:2.0 position:CSToastPositionTop];
        } else {
            [self.contentView makeToast:@"昵称设置成功" duration:2.0 position:CSToastPositionTop];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
