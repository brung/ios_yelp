//
//  MostPopularFilter.m
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MostPopularFilter.h"

@implementation MostPopularFilter

- (id)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.apiKey = dictionary[@"apiKey"];
    }
    return self;
}

- (NSDictionary *)getAsDictionary {
    return @{@"name" : self.name, @"apiKey" : self.apiKey };
}

+ (NSArray *)getDictionariesFromFilters:(NSArray *)filters{
    NSMutableArray *results = [NSMutableArray array];
    for (MostPopularFilter *category in filters) {
        [results addObject:[category getAsDictionary]];
    }
    return results;
}

+ (NSArray *)getFiltersFromDicitionaries:(NSArray *)dicts {
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        [results addObject:[[MostPopularFilter alloc] initWithDictionary:dict]];
    }
    return results;
}

+ (NSArray *)getMostPopularFilters {
    NSArray *filters = @[@{@"name" : @"Offering a Deal", @"apiKey" : @"deals_filter" }];
    NSMutableArray *resultsArray = [NSMutableArray array];
    for (NSDictionary *dict in filters) {
        MostPopularFilter *cat = [[MostPopularFilter alloc] initWithDictionary:dict];
        [resultsArray addObject:cat];
    }
    return resultsArray;
}

@end
