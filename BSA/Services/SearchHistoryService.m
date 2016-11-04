//
//  SearchHistoryService.m
//  RTA
//
//  Created by tangwei1 on 16/10/31.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "SearchHistoryService.h"
#import "BuslineSearchHistory.h"
#import "BuslineSearchHistoryTable.h"
#import "LocationSearchHistory.h"
#import "LocationSearchHistoryTable.h"
#import "CTPersistanceTable+Find.h"
#import "CTPersistanceTable+Insert.h"
#import "CTPersistanceTable+Delete.h"

@interface SearchHistoryService ()

@property (nonatomic) dispatch_queue_t queryQueue;
@property (nonatomic) dispatch_queue_t insertQueue;

@property (nonatomic, strong) BuslineSearchHistoryTable  *bshTable;
@property (nonatomic, strong) LocationSearchHistoryTable *lshTable;

@end
@implementation SearchHistoryService

+ (instancetype)sharedInstance
{
    static SearchHistoryService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[SearchHistoryService alloc] init];
        }
    });
    return instance;
}

- (void)loadLatestBuslineHistories:(void (^)(NSArray *results, NSError *error))completion
{
    dispatch_async(self.queryQueue, ^{
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.orderBy = @"time";
        criteria.isDESC  = YES;
        criteria.limit   = 5;
        
        NSError *inError = nil;
        NSArray *temp  = [self.bshTable findAllWithCriteria:criteria error:&inError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( inError ) {
                if ( completion ) {
                    completion(nil, inError);
                }
            } else {
                if ( completion ) {
                    completion(temp, nil);
                }
            }
        });
        
    });
}

- (void)insertBuslineHistory:(BuslineSearchHistory *)history
                  completion:(void (^)(BOOL succeed, NSError *error))completion
{
    dispatch_async(self.insertQueue, ^{
        
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.whereCondition = @"startName = :sName and endName = :eName";
        criteria.whereConditionParams = @{ @"sName": history.startName,
                                           @"eName": history.endName
                                           };
        id obj = [self.bshTable findFirstRowWithCriteria:criteria error:nil];
        
        if ( !obj ) {
            NSError *inError = nil;
            [self.bshTable insertRecord:history error:&inError];
            if ( inError ) {
                NSLog(@"insert error: %@", inError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ( completion ) {
                        completion(NO, inError);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ( completion ) {
                        completion(YES, nil);
                    }
                });
            }
        } else {
            NSLog(@"重复插入");
        }
        
    });
    
}

- (void)removeAllBuslineHistories:(void (^)(BOOL succeed, NSError *error))completion
{
    dispatch_async(self.queryQueue, ^{
        NSError *inError = nil;
        [self.bshTable deleteWithWhereCondition:nil conditionParams:nil error:&inError];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( inError ) {
                if ( completion ) {
                    completion(NO, inError);
                }
            } else {
                if ( completion ) {
                    completion(YES, nil);
                }
            }
        });
    });
}

- (void)loadLatestSearchKeywordHistories:(void (^)(NSArray *results, NSError *error))completion
{
    dispatch_async(self.queryQueue, ^{
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.orderBy = @"time";
        criteria.isDESC  = YES;
        criteria.limit   = 5;
        
        NSError *inError = nil;
        NSArray *temp  = [self.lshTable findAllWithCriteria:criteria error:&inError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( inError ) {
                if ( completion ) {
                    completion(nil, inError);
                }
            } else {
                if ( completion ) {
                    completion(temp, nil);
                }
            }
        });
        
    });
}

- (void)insertLocSearchHistory:(LocationSearchHistory *)history completion:(void (^)(BOOL, NSError *))completion
{
    dispatch_async(self.insertQueue, ^{
        
        CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
        criteria.whereCondition = @"keyword = :keyword";
        criteria.whereConditionParams = @{ @"keyword": history.keyword,
                                           };
        id obj = [self.lshTable findFirstRowWithCriteria:criteria error:nil];
        
        if ( !obj ) {
            NSError *inError = nil;
            [self.lshTable insertRecord:history error:&inError];
            if ( inError ) {
                NSLog(@"insert error: %@", inError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ( completion ) {
                        completion(NO, inError);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ( completion ) {
                        completion(YES, nil);
                    }
                });
            }
        } else {
            NSLog(@"重复插入");
        }
        
    });
}

- (void)removeAllLocSearchHistories:(void (^)(BOOL succeed, NSError *error))completion
{
    dispatch_async(self.queryQueue, ^{
        NSError *inError = nil;
        [self.lshTable deleteWithWhereCondition:nil conditionParams:nil error:&inError];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( inError ) {
                if ( completion ) {
                    completion(NO, inError);
                }
            } else {
                if ( completion ) {
                    completion(YES, nil);
                }
            }
        });
    });
}

- (dispatch_queue_t)queryQueue
{
    if ( !_queryQueue ) {
        _queryQueue = dispatch_queue_create("search.query.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queryQueue;
}

- (dispatch_queue_t)insertQueue
{
    if ( !_insertQueue ) {
        _insertQueue = dispatch_queue_create("search.insert.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _insertQueue;
}

- (BuslineSearchHistoryTable *)bshTable
{
    if ( !_bshTable ) {
        _bshTable = [[BuslineSearchHistoryTable alloc] init];
    }
    return _bshTable;
}

- (LocationSearchHistoryTable *)lshTable
{
    if ( !_lshTable ) {
        _lshTable = [[LocationSearchHistoryTable alloc] init];
    }
    return _lshTable;
}

@end
