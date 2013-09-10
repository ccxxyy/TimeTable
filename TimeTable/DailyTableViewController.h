//
//  DailyTableViewController.h
//  TimeTable
//
//  Created by Xiaoyi Cai on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MODULELABEL_TAG 1
#define DESCRIPTIONLABEL_TAG 2
#define IMAGE_TAG 3
#define PLACELABEL_TAG 6

@class WelcomeViewController;

@interface DailyTableViewController : UITableViewController {
    // define a dictionary file to store the value from json file 1
    NSDictionary *myDailyTableViewModel;
    // define a dictionary file to store the value from json file 2
    NSDictionary *semesterModule;
    // a nsstring which is set in welcomeViewController
    NSString *dayDetail;
    // stand for the type of the class
    NSString *type;
    // the cell in the table view
    UITableViewCell *myDailyTableCell;
    // a mutable array to receive the array form other class
    NSMutableArray *status1;

}

@property (nonatomic, retain) NSString *dayDetail;
@property (nonatomic, retain) IBOutlet UITableViewCell *myDailyTableCell;

- (void)initDailyTableViewModel;
-(void) set1: (NSMutableArray *)i;
-(NSMutableArray *) get1;

@end
