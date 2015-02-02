//
//  RestaurantCategory.h
//  Yelp
//
//  Created by Bruce Ng on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantCategory : NSObject
+ (NSArray *)getRestaurantCategories;
+ (NSArray *)getDictionariesFromFilters:(NSArray *)filters;
+ (NSArray *)getFiltersFromDicitionaries:(NSArray *)dicts;


@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@end
