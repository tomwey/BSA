//
//  VersionCheckerService.m
//  RTA
//
//  Created by tangwei1 on 16/10/26.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "VersionCheckService.h"
#import "Defines.h"

@interface VersionCheckService ()

@property (nonatomic, assign) BOOL checking;

@property (nonatomic, strong, readwrite) id appInfo;

@property (nonatomic, assign) BOOL silent;

@end

@implementation VersionCheckService

+ (instancetype)sharedInstance
{
    static VersionCheckService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[VersionCheckService alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(startCheck)
                                                         name:UIApplicationWillEnterForegroundNotification
                                                       object:nil];
        }
    });
    return instance;
}

- (void)startCheck
{
    [self startCheckWithSilent:YES];
}

- (void)startCheckWithSilent:(BOOL)isSilent
{
    if ( self.checking ) {
        return;
    }
    
    self.checking = YES;
    
    self.silent = isSilent;
    
    if ( !isSilent ) {
        [MBProgressHUD showHUDAddedTo:AWAppWindow() animated:YES];
    }
    
    [self.dataService POST:GET_RT_RESULT params:@{} completion:^(id result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:AWAppWindow() animated:YES];
        self.checking = NO;
        
        [self handleResult:result error: error];
    }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    if ( !error ) {
        self.appInfo = result;
        
        [self checkVersion];
    } else {
        self.checking = NO;
        
        if ( !self.silent ) {
            [AWAppWindow() makeToast:@"获取版本信息失败" duration:2.0 position:CSToastPositionTop];
        } else {
            
        }
    }
}

- (void)checkVersion
{
//    AndroidDownload = "http://182.150.21.101:9091/APK/RT/0.0.1.apk";
//    AndroidVersion = "0.0.1";
//    IosDownload = "http://182.150.21.101:9091/APK/RT/0.0.1.apk";
//    IosVersion = "0.0.1";
//    QQ = 2757801355;
//    QRDownLoadUrl = "http://182.150.21.101:9091/Images/QRCode/xiazai.png";
//    QRUrl = "http://182.150.21.101:9091/Images/QRCode/fenxiang.jpg";
//    Tel = 18108037442;
//    resultdes = "\U6267\U884c\U6210\U529f";
//    status = 101;
    if ( [AWAppVersion() compare:[[self.appInfo valueForKey:@"IosVersion"] description] options:NSNumericSearch] == NSOrderedAscending ) {
        // 有新版本更新
        [[[UIAlertView alloc] initWithTitle:@"有新版本，是否更新？" message:@""
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles: @"不了", @"立即更新", nil] show];
    } else {
        // 没有新版本
        if ( !self.silent ) {
            [[[UIAlertView alloc] initWithTitle:@"当前版本已经是最新的了" message:@""
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"确定", nil] show];
        } else {
            self.checking = NO;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.checking = NO;
    
    if ( buttonIndex == 1 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.appInfo valueForKey:@"IosDownload"] description]]];
    }
}

@end
