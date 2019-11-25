//
//  ViewController.m
//  SearchGit
//
//  Created by Bartek Bugajski on 25/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;
@synthesize searchController;
@synthesize allItems;
@synthesize displayedItems;
@synthesize filteredItems;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a list of fruit to display in the table view.
    
    /*
    self.allItems = [[NSMutableArray alloc] init];
    [self.allItems addObject:@"Apples"];
    [self.allItems addObject:@"Oranges"];
    [self.allItems addObject:@"Pears"];
    [self.allItems addObject:@"Grapes"];
    [self.allItems addObject:@"Grapefruits"];
    [self.allItems addObject:@"Lemons"];
    [self.allItems addObject:@"Peaches"];
    [self.allItems addObject:@"Pineapples"];
    [self.allItems addObject:@"Cherries"];
    [self.allItems addObject:@"Bananas"];
    [self.allItems addObject:@"Watermelons"];
    [self.allItems addObject:@"Cantaloupes"];
    [self.allItems addObject:@"Limes"];
    [self.allItems addObject:@"Strawberries"];
    [self.allItems addObject:@"Blueberries"];
    [self.allItems addObject:@"Raspberries"];
    */
    
    
    [self fetchUsersUsingJSON];
    
    // Create a list to hold search results (filtered list)
    self.filteredItems = [[NSMutableArray alloc] init];
    
    // Initially display the full list.  This variable will toggle between the full and the filtered lists.
    self.displayedItems = self.usernames;
    
    // Here's where we create our UISearchController
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar sizeToFit];
    
    // Add the UISearchBar to the top header of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Hides search bar initially.  When the user pulls down on the list, the search bar is revealed.
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchUsersUsingJSON {
    NSLog(@"Fetching usernames");
    NSString *urlString = @"https://api.github.com/users?q=";
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Usernames fetching finished.");
        
        
        NSError *err;
        NSArray *usersJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSMutableArray<User *> *usernames = NSMutableArray.new;
        for (NSDictionary *usersDictionary in usersJSON) {
            NSString *name = usersDictionary[@"items:login"];
            NSURL *avatar =[NSURL URLWithString:[usersDictionary objectForKey:@"avatar_url"]];
            User *username = User.new;
            username.name = name;
            username.avatar = avatar;
            [usernames addObject:username];
        
        }
        NSLog(@"%@", usernames);
     self.usernames = usernames;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }] resume];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredItems count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath {
    
    UITableViewCell * cell = [aTableView dequeueReusableCellWithIdentifier:@"FruitCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [self.displayedItems objectAtIndex:anIndexPath.row];
    return cell;
}

// When the user types in the search bar, this method gets called.
- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    NSLog(@"updateSearchResultsForSearchController");
    
    NSString *searchString = aSearchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
    
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        [self.filteredItems removeAllObjects];
        for (NSString *str in self.usernames) {
            if ([searchString isEqualToString:@""] || [str localizedCaseInsensitiveContainsString:searchString] == YES) {
                NSLog(@"str=%@", str);
                [self.filteredItems addObject:str];
            }
        }
        self.displayedItems = self.filteredItems;
    }
    else {
        self.displayedItems = self.usernames;
    }
    [self.tableView reloadData];
}


@end
