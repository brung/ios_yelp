//
//  FilterHeaderView.m
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterHeaderView.h"

@implementation FilterHeaderView


- (UILabel *)headerLabel
{
    if (!_headerLabel)
    {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headerLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_headerLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[header]-(>=8)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{ @"header": _headerLabel }]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[header]-(>=0)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{ @"header": _headerLabel }]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_headerLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
    }
   
    return _headerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
