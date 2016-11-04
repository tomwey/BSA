//
//  LocationSearchHistory.h
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface LocationSearchHistory : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *id_;
@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, strong) NSNumber *time;

@end
