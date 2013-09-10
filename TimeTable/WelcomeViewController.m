//
//  WelcomeViewController.m
//  TimeTable
//
//  Created by Xiaoyi Cai on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"
#import "DailyTableViewController.h"
#import "CustomiseViewController.h"

@implementation WelcomeViewController

@synthesize welcomeTableView;
@synthesize delegate1;

//int i=1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // set the title of this view
    [self setTitle:@"TimeTable"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// set the array from CustomiseViewController to this class
-(void) set: (NSMutableArray *)i {
    
    status= i;
}

// return the value which is set in former method
- (NSMutableArray *) get {
    return status;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ==================================================================================

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    // Return the number of sections.
    
    return 1;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    // Return the number of rows in the section.
    
    return 5;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *CellIdentifier = @"Cell";
    
    
    // define a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // change the view, when cell is been clicked
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    // initialize the array
    myDataArray = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday",
                   
                   @"Wednesday", @"Thursday", @"Friday", nil];
    
    
    // Configure the cell...
    
    [[cell textLabel] setText:[myDataArray objectAtIndex:[indexPath row]]];  
    
    return cell;
    
}



// ==================================================================================

#pragma mark - Table view delegate

// when the button is been clicked, this method will be called
- (IBAction)customiseButtonPressed{
    
    // change to a new model view when button has been pressed
    // following code is to change the current view to DailyTableView
    
     CustomiseViewController *customise= [[CustomiseViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [customise set3:[self get]];
    [customise setDelegate:self];
    myNavigation=[[UINavigationController alloc] initWithRootViewController:customise];
    myNavigation.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    
    
    
    [self.navigationController presentModalViewController:myNavigation animated:YES];
    
    [myNavigation release];
    
    [customise release];
    
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // Navigation logic may go here. Create and push another view controller.
    
     DailyTableViewController *DailyTableView= [[DailyTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [DailyTableView set1:[self get]];
    NSLog(@"status1 is %@", [DailyTableView get1]);
    // set the day which has been chosen to an attribute that defined in DailyTableViewController
     NSString *day = [myDataArray objectAtIndex:[indexPath row]];
    [DailyTableView setDayDetail:day];
    
    // Pass the selected object to the new view controller.

    [self.navigationController pushViewController:DailyTableView animated:YES];
    
    [DailyTableViewController release];
    
}



// ==================================================================================

@end
