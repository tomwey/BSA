//
//  InviteVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "InviteVC.h"
#import "Defines.h"
#import <MessageUI/MessageUI.h>
#import <ShareSDK/ShareSDK.h>

@interface InviteVC () <MFMessageComposeViewControllerDelegate>

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"邀请好友";
    
    self.contentView.backgroundColor = AWColorFromRGB(251, 251, 251);
    
    UIImageView *wxView = AWCreateImageView(nil);
    wxView.frame = CGRectMake(0, 0, 258, 258);
    if ( self.contentView.width == 320 ) {
        wxView.frame = CGRectMake(0, 0, 180, 180);
    }
    [self.contentView addSubview:wxView];
    
    [wxView setImageWithURL:[NSURL URLWithString:[[[VersionCheckService sharedInstance] appInfo] valueForKey:@"QRUrl"]]];
    
    wxView.center = CGPointMake(self.contentView.width / 2, 30 + wxView.height / 2);
    
    UILabel *tipLabel = AWCreateLabel(CGRectMake(0, wxView.bottom + 20,
                                                 self.contentView.width,
                                                 34),
                                      @"扫描二维码下载客户端, 我的公交出行必备～",
                                      NSTextAlignmentCenter,
                                      AWSystemFontWithSize(14, NO),
                                      AWColorFromRGB(201, 201, 201));
    [self.contentView addSubview:tipLabel];
    
    UILabel *inviteLabel = AWCreateLabel(CGRectMake(0, 0, 50, 34),
                                         @"邀请",
                                         NSTextAlignmentCenter,
                                         nil,
                                         tipLabel.textColor);
    [self.contentView addSubview:inviteLabel];
    inviteLabel.backgroundColor = self.contentView.backgroundColor;
    
    inviteLabel.center = CGPointMake(self.contentView.width / 2, tipLabel.bottom + 10 + inviteLabel.height / 2);
    
    CGFloat width = ( self.contentView.width - inviteLabel.width ) / 2 + 2;
    
    UIView *line1 = [AWHairlineView horizontalLineWithWidth:width
                                                      color:tipLabel.textColor
                                                     inView:self.contentView];
    line1.center = CGPointMake(line1.width / 2, inviteLabel.midY);
    
    UIView *line2 = [AWHairlineView horizontalLineWithWidth:width
                                                      color:tipLabel.textColor
                                                     inView:self.contentView];
    line2.center = CGPointMake(line2.width / 2 + inviteLabel.right - 1, inviteLabel.midY);
    
    [self.contentView bringSubviewToFront:inviteLabel];
    
    // 4个分享按钮
    NSArray *names = @[@"btn_wx.png", @"btn_friends.png", @"btn_qq.png", @"btn_message.png"];
    CGFloat padding = 10;
    
    for (int i = 0; i < names.count; i++) {
        UIButton *btn = AWCreateImageButton(names[i], self, @selector(btnClicked:));
        [self.contentView addSubview:btn];
        
        static CGFloat left;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CGFloat width = btn.width;
            left = ( self.contentView.width - width * names.count - padding * ( names.count - 1) ) / 2;
        });
        
        btn.center = CGPointMake(left + btn.width / 2 + ( btn.width + padding ) * i,
                                 inviteLabel.bottom + 10 + btn.height / 2);
        
        btn.tag = 100 + i;
    }
    
    self.contentView.userInteractionEnabled = YES;
}

- (void)btnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            [self shareToWX];
        }
            break;
        case 101:
        {
            [self shareToFriends];
        }
            break;
        case 102:
        {
            [self shareToQQ];
        }
            break;
        case 103:
        {
            [self shareToMessage];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareToWX
{
    NSLog(@"1234");
    [self shareToPlatform:SSDKPlatformSubTypeWechatSession];
}

- (void)shareToFriends
{
//    NSLog(@"1234");
    [self shareToPlatform:SSDKPlatformSubTypeWechatTimeline];
}

- (void)shareToQQ
{
//    NSLog(@"1234");
    [self shareToPlatform:SSDKPlatformSubTypeQQFriend];
}

- (void)shareToPlatform:(SSDKPlatformType)type// params:(NSMutableDictionary *)params
{
    NSMutableDictionary *params = [@{} mutableCopy];
//    [params SSDKEnableUseClientShare];
    
    [params SSDKSetupShareParamsByText:nil
                                images:AWImageNoCached(@"logo.png")
                                   url:[self shareLink]
                                 title:@"不再傻等，掐点出门。哈密实时公交，您的掌上公交神器。"
                                  type:SSDKContentTypeWebPage];
    
    [ShareSDK share:type
         parameters:params
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self.contentView makeToast:@"分享成功" duration:2.0 position:CSToastPositionTop];
             }
                 break;
             case SSDKResponseStateFail:
             {
                 NSLog(@"error: %@", error);
                 if ( type == SSDKPlatformSubTypeWechatSession ||
                     type == SSDKPlatformSubTypeWechatTimeline) {
                     [self.contentView makeToast:@"还未安装微信客户端" duration:2.0 position:CSToastPositionTop];
                 } else {
                     [self.contentView makeToast:@"还未安装QQ客户端" duration:2.0 position:CSToastPositionTop];
                 }
                 
             }
                 break;
             case SSDKResponseStateCancel:
             {
                 [self.contentView makeToast:@"分享取消" duration:2.0 position:CSToastPositionTop];
             }
                 break;
                 
             default:
                 break;
         }
     }];
}

- (void)shareToMessage
{
//    NSLog(@"1234");
    if ( ![MFMessageComposeViewController canSendText] ) {
        [[[UIAlertView alloc] initWithTitle:@"您的设备不支持发短信"
                                   message:@""
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil] show];
        return;
    }
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    vc.body = [self shareContent];
    vc.messageComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
        {
            [self.contentView makeToast:@"取消发送" duration:2.0 position:CSToastPositionTop];
        }
            break;
        case MessageComposeResultFailed:
        {
            [self.contentView makeToast:@"发送消息失败" duration:2.0 position:CSToastPositionTop];
        }
            break;
        case MessageComposeResultSent:
        {
            [self.contentView makeToast:@"消息已发送" duration:2.0 position:CSToastPositionTop];
        }
            break;
            
        default:
            break;
    }
}

- (NSURL *)shareLink
{
    NSString *url = [[[VersionCheckService sharedInstance] appInfo] valueForKey:@"QRUrl"];
    return [NSURL URLWithString:url];
}

- (NSString *)shareContent
{
    return [NSString stringWithFormat:@"不再傻等，掐点出门。哈密实时公交，您的掌上公交神器。\n%@",
            [[[VersionCheckService sharedInstance] appInfo] valueForKey:@"QRUrl"]];
}

@end
