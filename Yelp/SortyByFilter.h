//
//  SortyByFilter.h
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortyByFilter : NSObject
+ (NSArray *)getFilterOptions;


@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@end
