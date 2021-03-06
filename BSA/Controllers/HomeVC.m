//
//  HomeVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "HomeVC.h"
#import "Defines.h"

@interface HomeVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, assign) NSUInteger pageSize;

@property (nonatomic, assign) BOOL isLoadingNextPage;
@property (nonatomic, assign) BOOL loading;

@property (nonatomic, assign) CGFloat brightness;

@end

@implementation HomeVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商务班车"
                                                        image:[UIImage imageNamed:@"bus.png"]
                                                selectedImage:[UIImage imageNamed:@"bus_selected.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPage = 1;
    self.pageSize = 15;
    
    UIView *capitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width,
                                                                    150)];
    capitionView.backgroundColor = MAIN_BLUE_COLOR;
    [self.contentView addSubview:capitionView];
    
    NSArray *buttons = @[@"chartered.png", @"ticket_b.png", @"order.png", @"coupon.png"];
    NSArray *titles  = @[@"我要包车", @"我的车票", @"我的订单", @"优惠券"];
    NSInteger i = 0;
    CGFloat left = 27;
    for (NSString *image in buttons) {
        UIButton *btn = AWCreateImageButton(image, self, @selector(homeBtnClick:));
        [capitionView addSubview:btn];
        
        static CGFloat padding;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            padding = ( capitionView.width - buttons.count * btn.width - left * 2 ) / (buttons.count - 1);
        });
        
        btn.center = CGPointMake(left + btn.width / 2 + ( btn.width + padding ) * i, capitionView.height / 2 - 5);
        
        UILabel *titleLabel = AWCreateLabel(CGRectMake(0, 0, 80, 30),
                                            titles[i],
                                            NSTextAlignmentCenter,
                                            AWSystemFontWithSize(16, NO),
                                            [UIColor whiteColor]);
        titleLabel.center = CGPointMake(btn.midX, btn.bottom + titleLabel.height / 2 + 5);
        [capitionView addSubview:titleLabel];
        
        btn.tag = i;
        
        i++;
    }
    
    CGRect frame = CGRectMake(0, 0, self.contentView.width,
                              self.contentView.height - 49 - capitionView.height);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    self.tableView.top = capitionView.bottom;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MAIN_BG_COLOR;
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate   = self;
    [self.tableView removeBlankCells];
    
    self.tableView.rowHeight = 156;
    
    __weak typeof(self) me = self;
    [self.tableView addRefreshControlWithReloadCallback:^(UIRefreshControl *control) {
        if ( control ) {
            [me refreshLoad];
        }
    }];
    
    [self startLoad];
    
    self.brightness = [UIScreen mainScreen].brightness;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIScreen mainScreen].brightness = self.brightness;
}

- (void)homeBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            // 我要包车
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"ApplyBusVC" params:nil];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            // 我的车票
            if ( ![[UserService sharedInstance] currentUser] ) {
                UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            } else {
                // 调整屏幕亮度
                if ( self.brightness < 0.8 ) {
                    [UIScreen mainScreen].brightness = 0.8;
                }
                UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"TicketsListVC" params:nil];
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:
        {
            // 我的订单
            if ( ![[UserService sharedInstance] currentUser] ) {
                UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            } else {
                UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OrderListVC" params:nil];
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:
        {
            // 优惠券
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"CouponVC" params:nil];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)startLoad
{
    if ( self.loading ) {
        return;
    }
    
    self.loading = YES;
    
    __weak typeof(self) me = self;
    if ( self.currentPage == 1 ) {
        [self startLoadingInView:self.tableView forStateViewClass:[AWLoadingStateView class] reloadCallback:^{
            [me refreshLoad];
        }];
    } else {
        // 加载更多的进度指示
    }
    
    [self.dataService POST:@"GetBusLineOrderPublishResult" params:@{ @"pageindex": @(self.currentPage),
                                                                     @"pagesize": @(self.pageSize)
                                                                     }
                completion:^(id result, NSError *error) {
                    NSLog(@"result: %@\nError: %@", result, error);
                    [me handleResult:result error: error];
                }];
}

- (NSInteger)calcuTotalPage:(NSInteger)total
{
    if ( self.pageSize == 0 ) {
        return 0;
    }
    
    return (total + self.pageSize - 1) / self.pageSize;
}

- (void)handleResult:(id)result error:(NSError *)error
{
    self.loading = NO;
    self.isLoadingNextPage = NO;
    
    [self.tableView finishLoading];
    
    if ( self.currentPage == 1 ) {
        if ( error ) {
            [self finishLoading:AWLoadingStateFailure];
        } else {
            NSArray *dataList = result[@"DataList"];
            if ( [dataList count] == 0 ) {
                [self finishLoading:AWLoadingStateEmptyResult];
            } else {
                NSInteger total = [result[@"Total"] integerValue];
                self.totalPage = [self calcuTotalPage:total];
                
                self.dataSource.dataSource = dataList;
                [self.tableView reloadData];
                
                [self finishLoading:AWLoadingStateSuccess];
            }
        }
    } else {
        if ( error ) {
            [self.contentView makeToast:@"加载数据失败" duration:2.0 position:CSToastPositionBottom];
        } else {
            NSArray *dataList = result[@"DataList"];
            
            if ( [dataList count] == 0 ) {
                [self.contentView makeToast:@"没有更多数据了" duration:2.0 position:CSToastPositionBottom];
            } else {
                NSMutableArray *array = [self.dataSource.dataSource mutableCopy];
                [array addObjectsFromArray:dataList];
                
                self.dataSource.dataSource = array;
                [self.tableView reloadData];
            }
        }
    }
}

- (void)refreshLoad
{
    self.currentPage = 1;
    
    [self startLoad];
}

- (void)loadNextPage
{
    if ( self.currentPage < self.totalPage ) {
        self.currentPage ++;
        
        [self startLoad];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !self.isLoadingNextPage &&
        self.totalPage > self.currentPage &&
        indexPath.row == self.dataSource.dataSource.count - 1 ) {
        self.isLoadingNextPage = YES;
        
        [self loadNextPage];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"BusCell", @"cell.id");
        
        __weak typeof(self) me = self;
        _dataSource.itemDidSelectBlock = ^(UIView<AWTableDataConfig> *sender, id selectedData) {
            NSString *url = [NSString stringWithFormat:@"%@?lineno=%@&monthtype=%@",
                             LINE_DETAIL_URL,
                             [selectedData valueForKey:@"LineNo"],
                             [selectedData valueForKey:@"MonthType"]];
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"BusOrderVC"
                                                                        params:@{ @"pageUrl": url,
                                                                                  @"title": @"订购",
                                                                                  }];
            [me.tabBarController.navigationController pushViewController:vc animated:YES];
            
//            WebViewVC *page = [[WebViewVC alloc] initWithURL:url title:@"线路订购详情"];
//            [me.tabBarController.navigationController pushViewController:page animated:YES];
        };
    }
    return _dataSource;
}

@end
