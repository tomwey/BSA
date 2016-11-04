//
//  LocationSearchHistoryTable.m
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "LocationSearchHistoryTable.h"
#import "LocationSearchHistory.h"

@implementation LocationSearchHistoryTable

- (NSString *)databaseName
{
    return @"db.sqlite";
}

- (NSString *)tableName
{
    return @"LocationSearchHistoryTable";
}

- (NSDictionary *)columnInfo
{
    return @{
             @"id_": @"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"keyword": @"TEXT",
             @"location": @"TEXT",
             @"time": @"INTEGER",
             };
}

- (Class)recordClass
{
    return [LocationSearchHistory class];
}

- (NSString *)primaryKeyName
{
    return @"id_";
}

@end
