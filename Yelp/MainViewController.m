//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//
#import "UIImageView+AFNetworking.h"
#import "MainViewController.h"
#import "YelpClient.h"
#import "FilterViewController.h"
#import "BusinessCell.h"
#import "Business.h"
#import "MapKit/MapKit.h"
#import "BusinessDetailViewController.h"

NSString * const kYelpConsumerKey = @"fgQ4OCxPj2MPVBMMMBuG7Q";
NSString * const kYelpConsumerSecret = @"uw3QzsyZAzcRYfMNensCcn8Vb0M";
NSString * const kYelpToken = @"DHP8ygCpJVrgYz6M2tzIilJbKNQYWJex";
NSString * const kYelpTokenSecret = @"Gaj-qGTtbkhpoJRUbjHQm6RTFoA";
static NSInteger const ListView = 0;
static NSInteger const MapView = 1;
static NSString * const BusinessCellIdentifier = @"BusinessCell";
static NSString * const DefaultSearch = @"Restaurants";
static NSInteger const ResultCount = 20;

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate, MKMapViewDelegate>
@property (nonatomic, strong) BusinessCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString *currentSearch;
@property (nonatomic) NSInteger totalResults;
@property (nonatomic) BOOL isUpdating;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger currentView;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController
- (BusinessCell *)prototypeCell {
    if(!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:BusinessCellIdentifier];
    }
    return _prototypeCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isUpdating = NO;
        self.currentPage = 0;
        self.currentSearch = DefaultSearch;
        self.filters = [NSDictionary dictionary];
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self fetchDataForNewSearch];
        self.title = @"Yelp";
        
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
        filterButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = filterButton;

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onRightButton)];
        filterButton.tintColor = [UIColor whiteColor];
        ;
        self.navigationItem.rightBarButtonItem = rightButton;
        
        //float leftButtonWidth = CGRectGetWidth(self.navigationItem.titleView.frame);
        UISearchBar *sb = [[UISearchBar alloc] init]; //WithFrame:CGRectMake(leftButtonWidth, 0, CGRectGetWidth(self.navigationItem.titleView.frame)-leftButtonWidth, CGRectGetHeight(self.navigationItem.titleView.frame))];
        sb.delegate = self;
        self.navigationItem.titleView = sb;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.errorMessageLabel.text = @"Sorry, no matches were found. Try broadening your search.";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:BusinessCellIdentifier bundle:nil] forCellReuseIdentifier:BusinessCellIdentifier];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
    
    self.mapView.delegate = self;
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake(37.774866,-122.394556);
    self.mapView.region = MKCoordinateRegionMakeWithDistance(test, 10000, 10000);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar delegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.currentSearch = ([searchText length] == 0) ? DefaultSearch : searchText;
    self.currentPage = 0;
    [self fetchBusinessesWithQuery:self.currentSearch params:self.filters];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.currentSearch = DefaultSearch;
    self.currentPage = 0;
    [self fetchBusinessesWithQuery:self.currentSearch params:self.filters];
}

#pragma mark - Filter delegate methods
- (void)filtersViewController:(FilterViewController *)filtersViewControlller didChangeFilters:(NSDictionary *)filters {
    self.filters = filters;
    [self fetchDataForNewSearch];
}

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.businesses.count -1) {
        if (self.totalResults > self.businesses.count) {
            [self fetchDataForNewPage];
            tableView.tableFooterView.hidden = NO;
        } else {
            tableView.tableFooterView.hidden = YES;
        }
    }
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:BusinessCellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[BusinessCell class]]) {
        BusinessCell *businessCell = (BusinessCell *)cell;
        businessCell.business = self.businesses[indexPath.row];
        //businessCell.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row+1, business.name];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BusinessDetailViewController *vc = [[BusinessDetailViewController alloc] init];
    vc.business = self.businesses[indexPath.row];
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MapView methods
- (void) showPinsOnMapView {
    for (int i = 0; i < MIN(20, self.businesses.count); i++) {
        [self.mapView addAnnotation:[self.businesses[i] asAnnotation]];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *mav = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationView"];
    mav.canShowCallout = YES;
    BusinessAnnotation *busAnno = (BusinessAnnotation *)annotation;
    UIImageView *ratingsImage;
    [ratingsImage setImageWithURL:busAnno.rating_img_url];
    [mav addSubview:ratingsImage];
    return mav;
}


#pragma mark - Private methods
- (void) onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRightButton {
    if (self.currentView == MapView) {
        self.navigationItem.rightBarButtonItem.title = @"Map";
        [self.tableView reloadData];
        [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            self.tableView.hidden = NO;
            self.mapView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
        self.currentView = ListView;
    } else {
        self.navigationItem.rightBarButtonItem.title = @"List";
        [self showPinsOnMapView];
        [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
        } completion:^(BOOL finished) {
        }];
        self.currentView = MapView;
    }
}

- (void)fetchDataForNewPage {
    if (!self.isUpdating) {
        self.isUpdating = YES;
        self.currentPage += 1;
        NSMutableDictionary *dict = [self.filters mutableCopy];
        NSInteger offset = self.currentPage * ResultCount;
        [dict setObject:@(offset) forKey:@"offset"];
        [self fetchBusinessesWithQuery:self.currentSearch params:dict];
    }
}

- (void)fetchDataForNewSearch {
    if (!self.isUpdating) {
        self.isUpdating = YES;
        self.currentPage = 0;
        [self fetchBusinessesWithQuery:self.currentSearch params:self.filters];
    }
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        self.totalResults = [response[@"total"] integerValue];
        if (self.totalResults == 0 && self.currentPage == 0) {
            self.tableView.hidden = YES;
            self.errorMessageLabel.hidden = NO;
        } else {
            self.tableView.hidden = NO;
            self.errorMessageLabel.hidden = YES;
        }
        
        NSArray *businessDictionaries = response[@"businesses"];
        if (self.currentPage == 0) {
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        } else {
            NSMutableArray *dict = [self.businesses mutableCopy];
            [dict addObjectsFromArray:[Business businessesWithDictionaries:businessDictionaries]];
            self.businesses = dict;
        }
        
        [self.tableView reloadData];
        self.isUpdating = NO;
        //NSLog(@"response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isUpdating = NO;
        NSLog(@"error: %@", [error description]);
    }];
}

@end
