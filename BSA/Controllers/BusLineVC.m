//
//  BusLineVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusLineVC.h"
#import "Defines.h"

@interface BusLineVC ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation BusLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"路线";
    
    self.contentView.backgroundColor = CONTENT_VIEW_BG_COLOR;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView removeBlankCells];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = self.contentView.backgroundColor;
    
    self.tableView.rowHeight = 90;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [self loadData];
}

- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    Location *startLoc = self.params[@"start"];
    Location *endLoc   = self.params[@"end"];
    
    NSDictionary *params = @{ @"originlng": @(startLoc.coordinate.longitude),
                              @"originlat": @(startLoc.coordinate.latitude),
                              @"destinationlng": @(endLoc.coordinate.longitude),
                              @"destinationlat": @(endLoc.coordinate.latitude),
                              @"city": @"哈密"
                              };
    [self.dataService POST:@"GetGdmp" params:params completion:^(id result, NSError *error) {
//        NSLog(@"result: %@, error: %@", result, error);
        [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
        
        if ( error ) {
//            [self finishLoading:LoadingStateFail];
            [self finishLoading:AWLoadingStateFailure];
        } else {
            id transits = [[result objectForKey:@"route"] objectForKey:@"transits"];
            if ( transits && [transits isKindOfClass:[NSArray class]] ) {
                if ( [transits count] > 0 ) {
                    self.dataSource.dataSource = transits;
                    [self.tableView reloadData];
                } else {
//                    [self finishLoading:LoadingStateEmptyResult];
                    [self finishLoading:AWLoadingStateEmptyResult];
                }
                
            }
        }
    }];
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"BusLineCell", @"cell.id");
        __weak typeof(self) me = self;
        _dataSource.itemDidSelectBlock = ^(UIView <AWTableDataConfig> *sender, id selectedObj) {
            
            Location *startLoc = me.params[@"start"];
            Location *endLoc   = me.params[@"end"];
            
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"BusLineDetailVC" params:@{ @"busline": selectedObj, @"startName": startLoc.title, @"endName": endLoc.title }];
            [me.navigationController pushViewController:vc animated:YES];
        };
    }
    return _dataSource;
}

@end
