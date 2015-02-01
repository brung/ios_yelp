//
//  FilterViewController.m
//  Yelp
//
//  Created by Bruce Ng on 1/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterHeaderView.h"
#import "DropDownMenuCell.h"
#import "MostPopularFilter.h"
#import "SwitchCell.h"
#import "RestaurantCategory.h"
#import "RestaurantCategoryCell.h"

static NSInteger const FILTER_TYPE_TOGGLES = 0;
static NSInteger const FILTER_TYPE_SELECT_ONE = 1;
static NSInteger const FILTER_TYPE_SELECT_MANY = 2;
static NSString * const DropDownMenuCellNibName = @"DropDownMenuCell";
static NSString * const SwitchCellNibName = @"SwitchCell";
static NSString * const RestaurantCategoryCellNibName = @"RestaurantCategoryCell";


@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, RestaurantCategoryCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// Filters to return back to delegate
@property (nonatomic, readonly) NSDictionary *filters;

@property (nonatomic, strong) NSArray *tableViewFilters;

// Most Popular Filters
@property (nonatomic, strong) NSArray *mostPopular;
@property (nonatomic, strong) NSMutableSet *selectedPopularFilters;

// Restaurant categories
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@property (nonatomic, strong) NSMutableSet *sectionExpanded;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedPopularFilters = [NSMutableSet set];
        self.selectedCategories = [NSMutableSet set];
        self.sectionExpanded = [NSMutableSet set];
        self.mostPopular = [MostPopularFilter getMostPopularFilters];
        self.categories = [RestaurantCategory getRestaurantCategories];
        
        self.tableViewFilters = @[@{@"title" : @"Most Popular", @"type" : @(FILTER_TYPE_TOGGLES), @"data" : self.mostPopular},
                                  @{@"title" : @"Restaurant Categories", @"type" : @(FILTER_TYPE_SELECT_MANY), @"data" : self.categories}];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:RestaurantCategoryCellNibName bundle:nil] forCellReuseIdentifier:RestaurantCategoryCellNibName];
    [self.tableView registerNib:[UINib nibWithNibName:SwitchCellNibName bundle:nil] forCellReuseIdentifier:SwitchCellNibName];
    [self.tableView registerNib:[UINib nibWithNibName:DropDownMenuCellNibName bundle:nil] forCellReuseIdentifier:DropDownMenuCellNibName];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewFilters.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FilterHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FilterHeaderView"];
    if (!header) {
        header = [[FilterHeaderView alloc] initWithReuseIdentifier:@"FilterHeaderView"];
    }
    header.headerLabel.text = self.tableViewFilters[section][@"title"];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *data = self.tableViewFilters[section][@"data"];
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = self.tableViewFilters[indexPath.section];
    if ([sectionDict[@"title"] isEqualToString:@"Restaurant Categories"]) {
        RestaurantCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:RestaurantCategoryCellNibName];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    } else if ([sectionDict[@"title"] isEqualToString:@"Most Popular"]) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellNibName];
        NSArray *sectionData = sectionDict[@"data"];
        MostPopularFilter *data = sectionData[indexPath.row];
        cell.toggleLabel.text = data.name;
        cell.delegate = self;
        cell.on = [self.selectedPopularFilters containsObject:data];
        return cell;
    } else {
        DropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:DropDownMenuCellNibName];
        cell.dropDownLabel.text = @"";
        [cell.selectionIcon setImage:[UIImage imageNamed:@"dropdown"]];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[RestaurantCategoryCell class]]) {
        RestaurantCategoryCell *rcCell = (RestaurantCategoryCell *)cell;
        rcCell.restaurantCategory = self.categories[indexPath.row];
        rcCell.delegate = self;
        rcCell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - SwitchCell Delegate Methods
- (void)switchCell:(SwitchCell *)cell didChangeValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (value) {
        [self.selectedPopularFilters addObject:self.mostPopular[indexPath.row]];
    } else {
        [self.selectedPopularFilters removeObject:self.mostPopular[indexPath.row]];
    }
}


#pragma mark - RestaurantCategoryCell Delegate Methods
- (void)restaurantCategoryCell:(RestaurantCategoryCell *)cell didChangeValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - Private Methods

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    NSLog(@"Setting filters");
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (RestaurantCategory *category in self.selectedCategories) {
            [names addObject:category.code];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    if (self.selectedPopularFilters.count > 0) {
        for (MostPopularFilter *mpf in self.selectedPopularFilters) {
            [filters setObject:@(YES) forKey:mpf.apiKey];
        }
    }
    NSLog(@"created filters %@", filters);
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
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
