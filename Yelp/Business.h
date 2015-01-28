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
@property (nonatomic, strong) NSArray* address;
@property (nonatomic, strong) NSArray* categories;



@end
