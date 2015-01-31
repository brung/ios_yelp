//
//  DropDownMenuCell.h
//  Yelp
//
//  Created by Bruce Ng on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectionIcon;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLabel;

@end
