//
//  RestaurantCategoryCell.m
//  Yelp
//
//  Created by Bruce Ng on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RestaurantCategoryCell.h"

@interface RestaurantCategoryCell ()
- (IBAction)switchValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *toggleLabel;

@end

@implementation RestaurantCategoryCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate restaurantCategoryCell:self didChangeValue:self.toggleSwitch.on];
}

#pragma mark - Restaurant population
- (void)setRestaurantCategory:(RestaurantCategory *)restaurantCategory {
    _restaurantCategory = restaurantCategory;
    self.toggleLabel.text = restaurantCategory.name;
}


@end
