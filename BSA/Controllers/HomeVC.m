//
//  HomeVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "HomeVC.h"
#import "Defines.h"

@interface HomeVC ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

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
    
    UIView *capitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width,
                                                                    self.contentView.width * 0.4167)];
    capitionView.backgroundColor = MAIN_BLUE_COLOR;
    [self.contentView addSubview:capitionView];
    
    NSArray *buttons = @[@"chartered.png", @"order.png", @"coupon.png"];
    NSArray *titles  = @[@"我要包车", @"我的订单", @"优惠券"];
    NSInteger i = 0;
    CGFloat left = 40;
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
    
    [self.tableView removeBlankCells];
    
    self.tableView.rowHeight = 156;
    
    [self startLoad];
}

- (void)homeBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            // 我要包车
        }
            break;
        case 2:
        {
            // 我的订单
        }
            break;
        case 3:
        {
            // 优惠券
        }
            break;
            
        default:
            break;
    }
}

- (void)startLoad
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataSource.dataSource = @[@{},@{}];
        [self.tableView reloadData];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)startLocation
{
    [[AWLocationManager sharedInstance] startUpdatingLocation:^(CLLocation *location, NSError *error) {
        if ( error ) {
            NSLog(@"获取位置失败：%@", error);
//            self.stationNameLabel.text = @"定位失败";
        } else {
            NSLog(@"%@", location.description);
            [self startFetchStation];
        }
    }];
}

- (void)startFetchStation
{
    NSString *lng_lat = [[AWLocationManager sharedInstance] formatedCurrentLocation_1];
    
    __weak typeof(self) me = self;
    [self.dataService POST:GET_STATION_BY_LNG_AND_LAT
                    params:@{ @"lng": [[lng_lat componentsSeparatedByString:@","] firstObject],
                              @"lat": [[lng_lat componentsSeparatedByString:@","] lastObject] }
                completion:^(id result, NSError *error) {
                    if ( error ) {
                        NSLog(@"获取站点失败：%@", error);
//                        self.stationNameLabel.text = @"站点获取失败";
                    } else {
//                        me.stationId = result[@"StationID"];
//                        me.stationNameLabel.text = [result[@"StationName"] description];
                        [me startFetchBusForLngAndLat:lng_lat];
                    }
                }];
}

- (void)startFetchBusForLngAndLat:(NSString *)lngAndLat
{
//    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
//    
//    __weak typeof(self) me = self;
//    [self.dataService POST:GET_BUS_LINE_QUERY_RESULT params:@{ @"stationid": self.stationId,
//                                                               @"lng": [[lngAndLat componentsSeparatedByString:@","] firstObject],
//                                                               @"lat":[[lngAndLat componentsSeparatedByString:@","] lastObject]
//                                                               } completion:^(id result, NSError *error) {
//                                                                   [MBProgressHUD hideHUDForView:me.contentView animated:YES];
//                                                                   [me handleLoadCompletion:result error:error];
//                                                               }];
}

- (void)handleLoadCompletion:(id)result error:(NSError *)error
{
    [self.tableView finishLoading];
    
    if ( !error ) {
        self.dataSource.dataSource = result[@"DataList"];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"BusCell", @"cell.id");
        
        __weak typeof(self) me = self;
        _dataSource.itemDidSelectBlock = ^(UIView<AWTableDataConfig> *sender, id selectedData) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?stationid=%@&lineno=%@&lineType=%@",
                                               LINE_DETAIL_URL,
                                               [selectedData valueForKey:@"StationID"],
                                               [[[selectedData valueForKey:@"BusLine"] description] trim],
                                               [selectedData valueForKey:@"LineType"]]];
            WebViewVC *page = [[WebViewVC alloc] initWithURL:url title:@"路线详情"];
            [me.tabBarController.navigationController pushViewController:page animated:YES];
        };
    }
    return _dataSource;
}

@end
