//
//  BusinessDetailViewController.m
//  Yelp
//
//  Created by Bruce Ng on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "BusinessDetailViewController.h"

@interface BusinessDetailViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *openStatusLabel;
@property (weak, nonatomic) IBOutlet MKMapView *localMap;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (NSString *)getDisplayCategories;
- (NSString *)getDisplayDistance;
- (NSString *)getDisplayReviewCount;
- (NSString *)getDisplayAddress;
- (NSString *)getDisplayPhone;

@end

@implementation BusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Details";
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButton)];
//    leftButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.backBarButtonItem.title = @"Search";
    
    
    self.localMap.delegate = self;
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake([self.business.coordinate[@"latitude"] floatValue], [self.business.coordinate[@"longitude"] floatValue]);
    self.localMap.region = MKCoordinateRegionMakeWithDistance(test, 1000, 1000);
    
    self.nameLabel.text = self.business.name;
    [self.backgroundImage setImageWithURL:self.business.image_url];
    [self.backgroundImage setAlpha:0.20];
    [self.ratingImage setImageWithURL:self.business.rating_img_url];
    self.reviewCountLabel.text = [self getDisplayReviewCount];
    self.distanceLabel.text = [self getDisplayDistance];
    self.addressLabel.text = [self getDisplayAddress];
    self.categoryLabel.text = [self getDisplayCategories];
    self.phoneLabel.text = [self getDisplayPhone];
    [self setOpenStatus];
    [self.localMap addAnnotation:[self.business asAnnotation]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MapView methods

#pragma mark - Business population
- (void) setOpenStatus {
    BOOL isClosed = self.business.is_closed;
    if (isClosed) {
        self.openStatusLabel.textColor = [UIColor redColor];
        self.openStatusLabel.text = @"Closed";
    } else {
        self.openStatusLabel.textColor = [UIColor greenColor];
        self.openStatusLabel.text = @"Open";
    }
}

- (NSString *)getDisplayAddress {
    NSMutableArray *addressArray =  [NSMutableArray arrayWithArray:self.business.address];
    if (self.business.neighborhoods.count != 0) {
        [addressArray addObject:self.business.neighborhoods[0]];
    }
    [addressArray addObject:self.business.city];
    [addressArray addObject:self.business.state_code];
    [addressArray addObject:self.business.postal_code];
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

- (NSString *)getDisplayPhone {
    if (self.business.display_phone != nil) {
    return [NSString stringWithFormat:@"Phone: %@", self.business.display_phone];
    }
    return @"";
}

#pragma mark - Private methods
- (void) onLeftButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
