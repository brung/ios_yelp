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
        business.categories = businessDict[@"categories"];
        business.display_phone = businessDict[@"display_phone"];
        business.distance = [businessDict[@"distance"] floatValue];
        business.image_url = businessDict[@"image_url"];
        business.is_claimed = [businessDict[@"is_claimed"] boolValue];
        business.is_closed = [businessDict[@"is_closed"] boolValue];
        business.address = [businessDict valueForKeyPath:@"location.address"];
        business.city = [businessDict valueForKey:@"location.city"];
        business.coordinate = [businessDict valueForKey:@"location.coordinate"];
        business.rating = [businessDict[@"distance"] floatValue];
        business.rating_img_url = businessDict[@"rating_img_url"];
        business.rating_img_url_large = businessDict[@"rating_img_url_large"];
        business.rating_img_url_small = businessDict[@"rating_img_url_small"];
        business.url = businessDict[@"url"];
        [businesses addObject:business];
        
    }
    
    NSArray *returnBusinesses = [businesses copy];
    return returnBusinesses;
}

@end
