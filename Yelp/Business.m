//
//  Business.m
//  Yelp
//
//  Created by Bruce Ng on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

+ (NSArray *) businessesWithDictionaries:(NSArray *)businessDictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *businessDict in businessDictionaries) {
        Business *business = [[Business alloc] init];
        business.name = businessDict[@"name"];
        business.address = [businessDict valueForKeyPath:@"location.address"];
        business.categories = businessDict[@"categories"];
        [businesses addObject:business];
        
    }
    
    NSArray *returnBusinesses = [businesses copy];
    return returnBusinesses;
}

@end
