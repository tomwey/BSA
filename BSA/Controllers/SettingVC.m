//
//  SettingVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "SettingVC.h"
#import "Defines.h"

@interface SettingVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak)   SettingTableHeader *tableHeader;

@end
@implementation SettingVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心"
                                                        image:[UIImage imageNamed:@"mine.png"]
                                                selectedImage:[UIImage imageNamed:@"mine_selected.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSArray alloc] initWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"Settings.plist" ofType:nil]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.height -= 49;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50;
    
    self.tableView.tableHeaderView = [[SettingTableHeader alloc] init];
    self.tableHeader = (SettingTableHeader *)self.tableView.tableHeaderView;
    
    __weak typeof(self) me = self;
    self.tableHeader.didSelectCallback = ^(SettingTableHeader *sender) {
        [me gotoUserProfile];
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.tableHeader.currentUser = [[UserService sharedInstance] currentUser];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell.id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    id obj = self.dataSource[indexPath.section][indexPath.row];
    
    if ( ![obj valueForKey:@"action"] ) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.imageView.image = [UIImage imageNamed:[[obj valueForKey:@"icon"] description]];
    cell.textLabel.text  = [[obj valueForKey:@"label"] description];
    cell.textLabel.textColor = AWColorFromRGB(135, 135, 135);
    
    NSString *value = [[obj valueForKey:@"value"] description];
    
    if ( [value isEqualToString:@"qq"] ) {
        value = [[[[VersionCheckService sharedInstance] appInfo] valueForKey:@"QQ"] description];
    } else if ( [value isEqualToString:@"cache"] ) {
        value = [NSString stringWithFormat:@"%.1fM", [[NSURLCache sharedURLCache] currentMemoryUsage] / 1024.0 / 1024.0];
    } else if ( [value isEqualToString:@"version"] ) {
        value = AWAppVersion();
    }
    
    cell.detailTextLabel.text = value;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id obj = self.dataSource[indexPath.section][indexPath.row];
    NSString *action = [[obj valueForKey:@"action"] description];
    
    SEL selector = NSSelectorFromString(action);
    if ( [self respondsToSelector:selector] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:nil];
#pragma clang diagnostic pop
    }
}

- (void)gotoUserProfile
{
    UIViewController *vc = nil;
    if ( ![[UserService sharedInstance] currentUser] ) {
        vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
    } else {
        vc = [[AWMediator sharedInstance] openVCWithName:@"UserVC" params:nil];
    }
    
    [[AWAppWindow() navController] pushViewController:vc animated:YES];
}

- (void)openNFC
{
    NSURL *nfcAppURL = [NSURL URLWithString:NFC_APP_URL];
    if ( [[UIApplication sharedApplication] canOpenURL:nfcAppURL] ) {
        [[UIApplication sharedApplication] openURL:nfcAppURL];
    } else {
        [self showAlertWithTitle:@"提示" message:@"您还未安装该应用"];
    }
}

- (void)gotoInvite
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"InviteVC" params:nil];
    [AWAppWindow().navController pushViewController:vc animated:YES];
}

- (void)clearCache
{
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.contentView animated:YES];
            [self.tableView reloadData];
        });
    });
}

- (void)gotoFeedback
{
//    WebViewVC *page = [[WebViewVC alloc] initWithURL:[NSURL URLWithString:FEEDBACK_URL] title:@"意见反馈"];
//    [AWAppWindow().navController pushViewController:page animated:YES];
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"FeedbackVC" params:nil];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

- (void)openQQ
{
    AWAppOpenQQ([[[[VersionCheckService sharedInstance] appInfo] valueForKey:@"QQ"] description]);
}

- (void)gotoWechat
{
    WebViewVC *page = [[WebViewVC alloc] initWithURL:[NSURL URLWithString:OFFICIAL_WECHAT_URL] title:@"官方微信"];
    [AWAppWindow().navController pushViewController:page animated:YES];
}

- (void)openPhone
{
    NSString *phone = [NSString stringWithFormat:@"tel:%@", [[[[VersionCheckService sharedInstance] appInfo] valueForKey:@"Tel"] description]];
    NSURL *phoneURL = [NSURL URLWithString:phone];
    
    if ( [AWDeviceName() rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound &&
        [[UIApplication sharedApplication] canOpenURL:phoneURL] ) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    } else {
        [self showAlertWithTitle:@"提示" message:@"您的设备不支持打电话功能"];
    }
}

- (void)gotoVersion
{
    [[VersionCheckService sharedInstance] startCheckWithSilent:NO];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"确定",nil] show];
}

@end
