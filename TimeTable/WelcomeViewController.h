//
//  WelcomeViewController.h
//  TimeTable
//
//  Created by Xiaoyi Cai on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    // define the table view
    UITableView *welcomeTableView;
    // the array to store monday to friday
    NSArray *myDataArray;
    // define a navigation controller
    UINavigationController *myNavigation;
    // a mutable array which will be used to get the value from customise view controller
    NSMutableArray *status; 
    // will be used in modal view
    id delegate1;
}

@property (atomic, retain) IBOutlet UITableView *welcomeTableView;
@property (nonatomic, retain) id delegate1;


- (IBAction)customiseButtonPressed;

-(void) set: (NSMutableArray *)i;
- (NSMutableArray *) get;

@end
