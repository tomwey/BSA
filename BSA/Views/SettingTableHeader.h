//
//  SettingTableHeader.h
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@interface SettingTableHeader : UIView

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, copy) void (^didSelectCallback)(SettingTableHeader *view);

@end
