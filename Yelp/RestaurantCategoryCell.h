//
//  RestaurantCategoryCell.h
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantCategory.h"

@class RestaurantCategoryCell;

@protocol RestaurantCategoryCellDelegate <NSObject>
- (void)restaurantCategoryCell:(RestaurantCategoryCell *)cell didChangeValue:(BOOL)value;
@end

@interface RestaurantCategoryCell : UITableViewCell
@property (nonatomic, assign) BOOL on;
@property (nonatomic, strong) RestaurantCategory *restaurantCategory;
@property (nonatomic, weak) id<RestaurantCategoryCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
