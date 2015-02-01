//
//  DistanceFilter.m
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DistanceFilter.h"

@implementation DistanceFilter
- (id)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.code = dictionary[@"code"];
    }
    return self;
}

+ (NSArray *) getFilterOptions {
    NSArray *sortOptions = @[@{@"name" : @"Best Match", @"code" : @(0)},
                             @{@"name" : @"0.3 miles", @"code" : @(483)},
                             @{@"name" : @"1 mile", @"code" : @(1610)},
                             @{@"name" : @"5 miles", @"code" : @(8047)},
                             @{@"name" : @"20 miles", @"code" : @(32187)},
                             ];
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (NSDictionary *dict in sortOptions) {
        DistanceFilter *cat = [[DistanceFilter alloc] initWithDictionary:dict];
        [resultsArray addObject:cat];
    }
    return resultsArray;
}
@end
