//
//  MostPopularFilter.h
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MostPopularFilter : NSObject
+ (NSArray *)getMostPopularFilters;
+ (NSArray *)getDictionariesFromFilters:(NSArray *)filters;
+ (NSArray *)getFiltersFromDicitionaries:(NSArray *)dicts;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* apiKey;
@end
