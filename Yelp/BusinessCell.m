//
//  BusinessCell.m
//  Yelp
//
//  Created by Bruce Ng on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.logoImage.layer.cornerRadius = 3;
    self.logoImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.logoImage.layer.cornerRadius = 3;
}

- (void)setBusiness:(Business *)business {
    _business = business;
    self.nameLabel.text = business.name;
    [self.logoImage setImageWithURL:business.image_url];
    [self.ratingImage setImageWithURL:business.rating_img_url];
    self.reviewCountLabel.text = [self getDisplayReviewCount];
    self.distanceLabel.text = [self getDisplayDistance];
    self.addressLabel.text = [self getDisplayAddress];
    self.categoriesLabel.text = [self getDisplayCategories];
}

- (NSString *)getDisplayAddress {
    NSMutableArray *addressArray =  [NSMutableArray arrayWithArray:self.business.address];
    if (self.business.neighborhoods.count == 0) {
        [addressArray addObject:self.business.city];
    } else {
        [addressArray addObject:self.business.neighborhoods[0]];
    }
    return [addressArray componentsJoinedByString:@", "];
}

- (NSString *)getDisplayCategories {
    NSMutableArray *catArray = [NSMutableArray array];
    for (NSArray *category in self.business.categories) {
        [catArray addObject:category[0]];
    }
    return [catArray componentsJoinedByString:@", "];
}

- (NSString *)getDisplayDistance {
    return [NSString stringWithFormat:@"%.2f mi", self.business.distance/5280];
}

- (NSString *)getDisplayReviewCount {
    return [NSString stringWithFormat:@"%ld Reviews", (long)self.business.review_count];
}

@end
