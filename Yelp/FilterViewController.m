//
//  FilterViewController.m
//  Yelp
//
//  Created by Bruce Ng on 1/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "RestaurantCategory.h"
#import "RestaurantCategoryCell.h"


static NSString * const RestaurantCategoryCellNibName = @"RestaurantCategoryCell";


@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, RestaurantCategoryCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        self.categories = [RestaurantCategory getRestaurantCategories];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:RestaurantCategoryCellNibName];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
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

#pragma mark - SwitchCell Delegate Methods
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
