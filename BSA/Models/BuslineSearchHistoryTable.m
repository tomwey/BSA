//
//  BuslineSearchHistoryTable.m
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BuslineSearchHistoryTable.h"
#import "BuslineSearchHistory.h"

@implementation BuslineSearchHistoryTable

- (NSString *)databaseName
{
    return @"db.sqlite";
}

- (NSString *)tableName
{
    return @"BuslineSearchHistoryTable";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"id_": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"startName": @"TEXT",
             @"startCoordinate": @"TEXT",
             @"endName": @"TEXT",
             @"endCoordinate": @"TEXT",
             @"time": @"INTEGER"
             };
}

- (Class)recordClass
{
    return [BuslineSearchHistory class];
}

- (NSString *)primaryKeyName
{
    return @"id_";
}

@end
