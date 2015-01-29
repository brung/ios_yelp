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
        if (businessDict[@"image_url"] != nil) {
            business.image_url = [NSURL URLWithString:businessDict[@"image_url"]];
        }
        business.is_claimed = [businessDict[@"is_claimed"] boolValue];
        business.is_closed = [businessDict[@"is_closed"] boolValue];
        business.address = [businessDict valueForKeyPath:@"location.address"];
        business.city = [businessDict valueForKey:@"location.city"];
        business.coordinate = [businessDict valueForKey:@"location.coordinate"];
        business.mobile_url = businessDict[@"mobile_url"];
        business.rating = [businessDict[@"distance"] floatValue];
        business.rating_img_url = [NSURL URLWithString:businessDict[@"rating_img_url"]];
        business.rating_img_url_large = [NSURL URLWithString:businessDict[@"rating_img_url_large"]];
        business.rating_img_url_small = [NSURL URLWithString:businessDict[@"rating_img_url_small"]];
        business.review_count = [businessDict[@"review_count"] integerValue];
        business.url = businessDict[@"url"];
        [businesses addObject:business];
        
    }
    
    NSArray *returnBusinesses = [businesses copy];
    return returnBusinesses;
}

@end
