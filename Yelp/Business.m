//
//  Business.m
//  Yelp
//
//  Created by Bruce Ng on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *) businessDict {
    self = [super init];
    if (self) {
        self.name = businessDict[@"name"];
        self.categories = businessDict[@"categories"];
        self.display_phone = businessDict[@"display_phone"];
        self.distance = [businessDict[@"distance"] floatValue];
        if (businessDict[@"image_url"] != nil) {
            self.image_url = [NSURL URLWithString:businessDict[@"image_url"]];
        }
        self.is_claimed = [businessDict[@"is_claimed"] boolValue];
        self.is_closed = [businessDict[@"is_closed"] boolValue];
        self.address = [businessDict valueForKeyPath:@"location.address"];
        self.city = [businessDict valueForKeyPath:@"location.city"];
        self.coordinate = [businessDict valueForKeyPath:@"location.coordinate"];
        self.neighborhoods = [businessDict valueForKeyPath:@"location.neighborhoods"];
        self.mobile_url = businessDict[@"mobile_url"];
        self.rating = [businessDict[@"distance"] floatValue];
        self.rating_img_url = [NSURL URLWithString:businessDict[@"rating_img_url"]];
        self.rating_img_url_large = [NSURL URLWithString:businessDict[@"rating_img_url_large"]];
        self.rating_img_url_small = [NSURL URLWithString:businessDict[@"rating_img_url_small"]];
        self.review_count = [businessDict[@"review_count"] integerValue];
        self.url = businessDict[@"url"];

    }
    return self;
}

+ (NSArray *) businessesWithDictionaries:(NSArray *)businessDictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *businessDict in businessDictionaries) {
        Business *business = [[Business alloc] initWithDictionary:businessDict];
        [businesses addObject:business];
        
    }
    
    return businesses;
}

@end
