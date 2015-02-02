//
//  BusinessAnnotation.m
//  Yelp
//
//  Created by Bruce Ng on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessAnnotation.h"

@implementation BusinessAnnotation
@synthesize coordinate;
@synthesize title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setTitle:(NSString *)pTitle {
    title = [NSString stringWithString:pTitle];
}

@end
