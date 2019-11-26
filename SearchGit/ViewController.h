//
//  ViewController.h
//  SearchGit
//
//  Created by Bartek Bugajski on 25/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSMutableArray * allItems;
@property (nonatomic, strong) NSMutableArray * filteredItems;
@property (nonatomic, strong) NSArray * displayedItems;
@property (nonatomic, strong) NSMutableArray<User *> *usernames;

@end


