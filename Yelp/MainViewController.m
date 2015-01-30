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

NSString * const kYelpConsumerKey = @"fgQ4OCxPj2MPVBMMMBuG7Q";
NSString * const kYelpConsumerSecret = @"uw3QzsyZAzcRYfMNensCcn8Vb0M";
NSString * const kYelpToken = @"DHP8ygCpJVrgYz6M2tzIilJbKNQYWJex";
NSString * const kYelpTokenSecret = @"Gaj-qGTtbkhpoJRUbjHQm6RTFoA";
static NSString *BusinessCellIdentifier = @"BusinessCell";
static NSString *DefaultSearch = @"Restaurants";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) BusinessCell *prototypeCell;
@property (nonatomic, strong) NSDictionary *filters;

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
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self fetchBusinessesWithQuery:DefaultSearch params:nil];
        self.title = @"Yelp";
        
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
        filterButton.tintColor = [UIColor whiteColor];
        filterButton.style = UIBarButtonItemStyleBordered;
        self.navigationItem.leftBarButtonItem = filterButton;
        
        float leftButtonWidth = CGRectGetWidth(self.navigationItem.titleView.frame);
        UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(leftButtonWidth, 0, CGRectGetWidth(self.navigationItem.titleView.frame)-leftButtonWidth, CGRectGetHeight(self.navigationItem.titleView.frame))];
        sb.delegate = self;
        self.navigationItem.titleView = sb;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:BusinessCellIdentifier bundle:nil] forCellReuseIdentifier:BusinessCellIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar delegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        searchText = DefaultSearch;
    }
    [self fetchBusinessesWithQuery:searchText params:self.filters];
}

#pragma mark - Filter delegate methods
- (void)filtersViewController:(FilterViewController *)filtersViewControlller didChangeFilters:(NSDictionary *)filters {
    self.filters = filters;
    [self fetchBusinessesWithQuery:DefaultSearch params:filters];
    NSLog(@"hit apply button %@", filters);
    
}

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:BusinessCellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 120;
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

#pragma mark - Private methods
- (void) onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *businessDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries:businessDictionaries] ;
        [self.tableView reloadData];
        NSLog(@"response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

@end
