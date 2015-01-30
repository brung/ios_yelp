//
//  Business.h
//  Yelp
//
//  Created by Bruce Ng on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject
+ (NSArray *)businessesWithDictionaries:(NSArray *)businessDictionaries;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSString* display_phone;
@property (nonatomic) float distance;
@property (nonatomic, strong) NSURL* image_url;
@property (nonatomic) BOOL is_claimed;
@property (nonatomic) BOOL is_closed;
@property (nonatomic, strong) NSArray* address;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSDictionary* coordinate;
@property (nonatomic, strong) NSString* mobile_url;
@property (nonatomic, strong) NSArray* neighborhoods;
@property (nonatomic) NSInteger phone;
@property (nonatomic) float rating;
@property (nonatomic, strong) NSURL* rating_img_url;
@property (nonatomic, strong) NSURL* rating_img_url_large;
@property (nonatomic, strong) NSURL* rating_img_url_small;
@property (nonatomic) NSInteger review_count;
@property (nonatomic, strong) NSString* url;



@end
