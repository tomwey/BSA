//
//  SearchHistoryService.h
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuslineSearchHistory,LocationSearchHistory;
@interface SearchHistoryService : NSObject

+ (instancetype)sharedInstance;

- (void)loadLatestBuslineHistories:(void (^)(NSArray *results, NSError *error))completion;

- (void)insertBuslineHistory:(BuslineSearchHistory *)history
                  completion:(void (^)(BOOL succeed, NSError *error))completion;

- (void)removeAllBuslineHistories:(void (^)(BOOL succeed, NSError *error))completion;

- (void)loadLatestSearchKeywordHistories:(void (^)(NSArray *results, NSError *error))completion;

- (void)insertLocSearchHistory:(LocationSearchHistory *)history
                    completion:(void (^)(BOOL succeed, NSError *error))completion;

- (void)removeAllLocSearchHistories:(void (^)(BOOL succeed, NSError *error))completion;

@end
