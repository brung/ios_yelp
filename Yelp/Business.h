//
//  Business.h
//  Yelp
//
//  Created by Bruce Ng on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

+(NSArray *) businessesWithDictionaries:(NSArray *)businessDictionaries;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSString* display_phone;
@property (nonatomic) float distance;
@property (nonatomic, strong) NSString* image_url;
@property (nonatomic) BOOL is_claimed;
@property (nonatomic) BOOL is_closed;
@property (nonatomic, strong) NSArray* address;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSDictionary* coordinate;
@property (nonatomic, strong) NSArray* neighborhoods;
@property (nonatomic) float rating;
@property (nonatomic) NSInteger phone;
@property (nonatomic, strong) NSString* rating_img_url;
@property (nonatomic, strong) NSString* rating_img_url_large;
@property (nonatomic, strong) NSString* rating_img_url_small;
@property (nonatomic, strong) NSString* url;



@end
