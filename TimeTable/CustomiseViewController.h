//
//  CustomiseViewController.h
//  TimeTable
//
//  Created by Xiaoyi Cai on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyTableViewController;
@class WelcomeViewController;
@interface CustomiseViewController : UITableViewController{
    // store the data from the json file
    NSMutableDictionary *myCustomiseView;
    // define a navigation controller
    UINavigationController *myNavigation1;
    // a mutable array to store the module which are selected by the user
    NSMutableArray *dic;
    // define a dailyTableViewController
    DailyTableViewController *dvc;
    id delegate;
    // define a WelcomeViewController
    WelcomeViewController *wvController;
    // a mutable array to store the data in former class
    NSMutableArray *status3; 

}

- (void)initCustomiseViewController;
-(void) set3: (NSMutableArray *)i ;
- (NSMutableArray *) get3 ;

@property (nonatomic, retain) id delegate;
//@property (nonatomic, retain) NSMutableArray *dic;


@end
