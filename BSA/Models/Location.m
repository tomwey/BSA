//
//  Location.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    if ( self = [super init] ) {
        self.coordinate = coordinate;
        self.title      = title;
    }
    return self;
}

@end
