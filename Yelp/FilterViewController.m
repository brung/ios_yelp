//
//  FilterViewController.m
//  Yelp
//
//  Created by Bruce Ng on 1/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "DropDownMenuCell.h"
#import "MostPopularFilter.h"
#import "DistanceFilter.h"
#import "SortyByFilter.h"
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

// Distance Filters
@property (nonatomic, strong) NSArray *distanceOptions;
@property (nonatomic) NSInteger selectedDistance;

// Sort Filters
@property (nonatomic, strong) NSArray *sortByOptions;
@property (nonatomic) NSInteger selectedSortBy;

// Restaurant categories
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *selectedCategories;

@property (nonatomic, strong) NSMutableSet *sectionExpanded;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedPopularFilters = [NSMutableSet set];
        self.selectedCategories = [NSMutableArray array];
        self.sectionExpanded = [NSMutableSet set];
        
        self.mostPopular = [MostPopularFilter getMostPopularFilters];
        self.distanceOptions = [DistanceFilter getFilterOptions];
        self.sortByOptions = [SortyByFilter getFilterOptions];
        self.categories = [RestaurantCategory getRestaurantCategories];
        self.tableViewFilters = @[@{@"title" : @"Most Popular", @"type" : @(FILTER_TYPE_TOGGLES), @"data" : self.mostPopular},
                                  @{@"title" : @"Distance", @"type" : @(FILTER_TYPE_SELECT_ONE), @"data" : self.distanceOptions},
                                  @{@"title" : @"Sort by", @"type" : @(FILTER_TYPE_SELECT_ONE), @"data" : self.sortByOptions},
                                  @{@"title" : @"Restaurant Categories", @"type" : @(FILTER_TYPE_SELECT_MANY), @"data" : self.categories}];
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *storedValue = [NSJSONSerialization JSONObjectWithData:[defaults objectForKey:@"filterCategories"] options:0 error:nil];
//        [self.selectedCategories addObjectsFromArray:storedValue];
//        storedValue = [NSJSONSerialization JSONObjectWithData:[defaults objectForKey:@"filterPopular"] options:0 error:nil];
//        [self.selectedPopularFilters addObjectsFromArray:storedValue];
//        self.selectedDistance = [defaults integerForKey:@"filterDistance"];
//        self.selectedSortBy = [defaults integerForKey:@"filterSortby"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableViewFilters[section][@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tableViewFilters[section][@"type"] integerValue] == FILTER_TYPE_SELECT_ONE &&
        ![self.sectionExpanded containsObject:@(section)]) {
        return 1;
    } else if ([self.tableViewFilters[section][@"type"] integerValue] == FILTER_TYPE_SELECT_MANY) {
        if (![self.sectionExpanded containsObject:@(section)]) {
            return self.selectedCategories.count+1;
        } else {
            NSArray *data = self.tableViewFilters[section][@"data"];
            return data.count+1;
        }
    }
    NSArray *data = self.tableViewFilters[section][@"data"];
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = self.tableViewFilters[indexPath.section];
    NSString *defaultCellLabel = @"See All";
    UIImage *defaultCellIcon = [UIImage imageNamed:@"dropdown"];
    if ([sectionDict[@"title"] isEqualToString:@"Restaurant Categories"]) {
        BOOL catExpanded = [self.sectionExpanded containsObject:@(indexPath.section)];
        if ((catExpanded && indexPath.row < self.categories.count) ||
            (!catExpanded && indexPath.row < self.selectedCategories.count)) {
            RestaurantCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:RestaurantCategoryCellNibName];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        } else {
            if (catExpanded) {
                defaultCellLabel = @"See Less";
                defaultCellIcon = [UIImage imageNamed:@"dropdowncollapse"];
            }
        }
    } else if ([sectionDict[@"title"] isEqualToString:@"Most Popular"]) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellNibName];
        NSArray *sectionData = sectionDict[@"data"];
        MostPopularFilter *data = sectionData[indexPath.row];
        cell.toggleLabel.text = data.name;
        cell.delegate = self;
        cell.on = [self.selectedPopularFilters containsObject:data];
        return cell;
    } else if ([sectionDict[@"title"] isEqualToString:@"Distance"]) {
        DropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:DropDownMenuCellNibName];
        NSArray *sectionData = sectionDict[@"data"];
        if ([self.sectionExpanded containsObject:@(indexPath.section)]) {
            DistanceFilter *data = sectionData[indexPath.row];
            cell.dropDownLabel.text = data.name;
            NSString *iconString = (self.selectedDistance == indexPath.row) ? @"Checkbox_selected" : @"Checkbox";
            [cell.selectionIcon setImage:[UIImage imageNamed:iconString]];
            return cell;
        } else {
            DistanceFilter *data = sectionData[self.selectedDistance];
            defaultCellLabel = data.name;
        }
    } else if ([sectionDict[@"title"] isEqualToString:@"Sort by"]) {
        DropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:DropDownMenuCellNibName];
        NSArray *sectionData = sectionDict[@"data"];
        if ([self.sectionExpanded containsObject:@(indexPath.section)]) {
            SortyByFilter *data = sectionData[indexPath.row];
            cell.dropDownLabel.text = data.name;
            NSString *iconString = (self.selectedSortBy == indexPath.row) ? @"Checkbox_selected" : @"Checkbox";
            [cell.selectionIcon setImage:[UIImage imageNamed:iconString]];
            return cell;
        } else {
            SortyByFilter *data = sectionData[self.selectedSortBy];
            defaultCellLabel = data.name;
        }
    }
    DropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:DropDownMenuCellNibName];
    cell.dropDownLabel.text = defaultCellLabel;
    [cell.selectionIcon setImage:defaultCellIcon];
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[RestaurantCategoryCell class]]) {
        RestaurantCategoryCell *rcCell = (RestaurantCategoryCell *)cell;
        BOOL catExpanded = [self.sectionExpanded containsObject:@(indexPath.section)];
        rcCell.restaurantCategory = catExpanded ? self.categories[indexPath.row] : self.selectedCategories[indexPath.row];
        rcCell.delegate = self;
        rcCell.on = !catExpanded || [self.selectedCategories containsObject:self.categories[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionInfo = self.tableViewFilters[indexPath.section];
    if ([sectionInfo[@"title"] isEqualToString:@"Distance"]) {
        if (![self.sectionExpanded containsObject:@(indexPath.section)]) {
            [self.sectionExpanded addObject:@(indexPath.section)];
            [self animateExpandSection:indexPath.section fromOldRows:1 toNewRows:((NSArray *)sectionInfo[@"data"]).count];
        } else {
            if (indexPath.row != self.selectedDistance) {
                NSInteger oldSelection = self.selectedDistance;
                self.selectedDistance = indexPath.row;
                [self animateUpdateOldSelection:oldSelection toIndexPath:indexPath andCollapseFromRowCount:((NSArray *)sectionInfo[@"data"]).count];
            } else {
                [self.sectionExpanded removeObject:@(indexPath.section)];
                [self animateExpandSection:indexPath.section fromOldRows:((NSArray *)sectionInfo[@"data"]).count toNewRows:1];
            }
        }
    } else if ([sectionInfo[@"title"] isEqualToString:@"Sort by"]) {
        if (![self.sectionExpanded containsObject:@(indexPath.section)]) {
            [self.sectionExpanded addObject:@(indexPath.section)];
            [self animateExpandSection:indexPath.section fromOldRows:1 toNewRows:((NSArray *)sectionInfo[@"data"]).count];
        } else {
            NSInteger oldSelection = self.selectedSortBy;
            if (indexPath.row != self.selectedSortBy) {
                self.selectedSortBy = indexPath.row;
                [self animateUpdateOldSelection:oldSelection toIndexPath:indexPath andCollapseFromRowCount:((NSArray *)sectionInfo[@"data"]).count];
            } else {
                [self.sectionExpanded removeObject:@(indexPath.section)];
                [self animateExpandSection:indexPath.section fromOldRows:((NSArray *)sectionInfo[@"data"]).count toNewRows:1];
            }
        }
    } else if ([sectionInfo[@"title"]isEqualToString:@"Restaurant Categories"]) {
        if (![self.sectionExpanded containsObject:@(indexPath.section)] &&
            indexPath.row >= self.selectedCategories.count) {
            [self.sectionExpanded addObject:@(indexPath.section)];
            [self animateExpandSection:indexPath.section fromOldRows:self.selectedCategories.count+1 toNewRows:((NSArray *)sectionInfo[@"data"]).count+1];
        } else if (indexPath.row >= self.categories.count) {
            [self.sectionExpanded removeObject:@(indexPath.section)];
            [self animateExpandSection:indexPath.section fromOldRows:((NSArray *)sectionInfo[@"data"]).count+1 toNewRows:self.selectedCategories.count+1];
        }
    }
}

- (void)animateExpandSection:(NSInteger)section fromOldRows:(NSInteger)oldRows toNewRows:(NSInteger)newRows {
    NSMutableArray *deleteIndexPaths = [NSMutableArray array];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    for (int i = 0; i < oldRows; i++) {
        [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    for (int i = 0; i < newRows; i++) {
        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [UIView animateWithDuration:1 animations:^{
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }];
}

- (void)animateUpdateOldSelection:(NSInteger)oldSelection toIndexPath:(NSIndexPath*)indexPath andCollapseFromRowCount:(NSInteger)oldRows {
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    [updateIndexPaths addObject:[NSIndexPath indexPathForRow:oldSelection inSection:indexPath.section]];
    [updateIndexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } completion:^(BOOL finished) {
        [self.sectionExpanded removeObject:@(indexPath.section)];
        [self animateExpandSection:indexPath.section fromOldRows:oldRows toNewRows:1];

    }];
    
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
    if (value) {
        [self.selectedCategories addObject:cell.restaurantCategory];
    } else {
        [self.selectedCategories removeObject:cell.restaurantCategory];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (![self.sectionExpanded containsObject:@(indexPath.section)]) {
            [UIView animateWithDuration:1 animations:^{
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }];
        }
    }
}

#pragma mark -DropDownMenuCell Delegate Methods
- (void)onTapDropDownCell:(DropDownMenuCell *)cell {
    
}

#pragma mark - Private Methods

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
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
    
    if (self.selectedDistance > 0) {
        DistanceFilter *distanceFilter = self.distanceOptions[self.selectedDistance];
        [filters setObject:distanceFilter.code forKey:@"radius_filter"];
    }
    
    if (self.selectedSortBy > 0) {
        SortyByFilter *sortByFilter = self.sortByOptions[self.selectedSortBy];
        [filters setObject:sortByFilter.code forKey:@"sort"];
    }

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//   [defaults setObject:[NSJSONSerialization dataWithJSONObject:self.selectedCategories options:0 error:nil] forKey:@"filterCategories"];
//    [defaults setObject:[NSJSONSerialization dataWithJSONObject:self.selectedPopularFilters options:0 error:nil]  forKey:@"filterPopular"];
//    [defaults setInteger:self.selectedDistance forKey:@"filterDistance"];
//    [defaults setInteger:self.selectedSortBy forKey:@"filterSortBy"];
//    [defaults synchronize];
    
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSearchButton {
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
