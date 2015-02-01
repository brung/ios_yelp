//
//  SortyByFilter.m
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SortyByFilter.h"

@implementation SortyByFilter
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
                             @{@"name" : @"Distance", @"code" : @(1)},
                             @{@"name" : @"Rating", @"code" : @(2)}];
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (NSDictionary *dict in sortOptions) {
        SortyByFilter *cat = [[SortyByFilter alloc] initWithDictionary:dict];
        [resultsArray addObject:cat];
    }
    return resultsArray;
}
@end
