//
//  TicketsListVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "TicketsListVC.h"
#import "Defines.h"

@interface TicketsListVC ()

@end

@implementation TicketsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"我的车票";
    
    [self.dataService POST:@"GetUserTikect" params:@{ @"userid": [[UserService sharedInstance] currentUserAuthToken] }
                completion:^(id result, NSError *error) {
                    NSLog(@"%@", result);
//                    {
//                        DataList =     (
//                        );
//                        Total = 0;
//                        resultdes = "\U6267\U884c\U6210\U529f";
//                        status = 101;
//                    }
                    // 每条数据
//                    {
//                        StartStation,
//                        StopStation,
//                        BusType,
//                        BusTypePic,
//                        BeginTime,
//                        EndTime,
//                        MD5,
//                    }
                }];
}

@end
