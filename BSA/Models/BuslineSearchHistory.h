//
//  BuslineSearchHistory.h
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface BuslineSearchHistory : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *id_;
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *startCoordinate; // 经度和纬度通过逗号连接到一起的值,例如：104.1234,30.901234
@property (nonatomic, copy) NSString *endName;
@property (nonatomic, copy) NSString *endCoordinate;

@property (nonatomic, strong) NSNumber *time;

@end
