//
//  FeedbackVC.m
//  RTA
//
//  Created by tangwei1 on 16/11/7.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "FeedbackVC.h"
#import "Defines.h"

@interface FeedbackVC ()

@property (nonatomic, weak) UITextView *bodyView;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.title = @"意见反馈";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, self.contentView.width - 30,
                                                                           120)];
    [self.contentView addSubview:textView];
    textView.placeholder = @"请输入您宝贵的意见，感谢您的支持";
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.cornerRadius = 2;
    
    textView.backgroundColor = [UIColor whiteColor];
    
    self.bodyView = textView;
    
    AWButton *sendBtn = [AWButton buttonWithTitle:@"提交" color:NAV_BAR_BG_COLOR];
    sendBtn.frame = textView.frame;
    sendBtn.height = 44;
    sendBtn.top = textView.bottom  + 20;
    [self.contentView addSubview:sendBtn];
    
    [sendBtn addTarget:self forAction:@selector(send:)];
}

- (void)send:(id)sender
{
    if ( [self.bodyView.text trim].length == 0 ) {
        [self.contentView makeToast:@"内容不能为空" duration:2.0 position:CSToastPositionTop];
        return;
    }
    
    [self.bodyView resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [self.dataService POST:@"AddAdvice" params:@{ @"userid": [[UserService sharedInstance] currentUserAuthToken] ?: @"",
                                                  @"content": [self.bodyView.text trim] ?: @""
                                                  } completion:^(id result, NSError *error) {
                                                      [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                                                      if ( !error ) {
                                                          [AWAppWindow() makeToast:@"意见反馈成功，感谢您宝贵的意见"
                                                                             duration:2.0
                                                                             position:CSToastPositionCenter];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      } else {
                                                          [self.contentView makeToast:@"提交失败" duration:2.0 position:CSToastPositionTop];
                                                      }
                                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
