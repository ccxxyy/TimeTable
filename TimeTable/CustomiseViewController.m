//
//  CustomiseViewController.m
//  TimeTable
//
//  Created by Xiaoyi Cai on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomiseViewController.h"
#import "SBJson.h"
#import "WelcomeViewController.h"
#import "DailyTableViewController.h"


@implementation CustomiseViewController

@synthesize delegate;
//@synthesize dic;
//int i;


- (void)initCustomiseViewController{
    // initialise the dictionary
    myCustomiseView = nil;
    
    // Generate the URL request for the JSON data
    
    NSURL *url1 = [NSURL URLWithString:@"http://www.csc.liv.ac.uk/people/trp/Teaching_Resources/COMP327/Semester1Modules.json"];
    
    
    // Get the contents of the URL as a string
    
    
    NSString *jsonString1 = [NSString stringWithContentsOfURL:url1
                             
                                                     encoding:NSUTF8StringEncoding error:nil];
    
    /*
     
     // Get the contents of the JSON file as a string
     
     NSString *filePath = [[NSBundle mainBundle]
     
     pathForResource:@"Monarchs1" ofType:@"json"];  
     
     NSString *jsonString = [NSString stringWithContentsOfFile:filePath
     
     encoding:NSUTF8StringEncoding error:nil];
     
     */
    
    if (jsonString1) {  
        
        myCustomiseView = [jsonString1 JSONValue];
        
        //NSLog(@"json is %@",myCustomiseView);
        
        [myCustomiseView retain];
        
        
    }   
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self initCustomiseViewController];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// set the mutable array with the value which is got from another class
-(void) set3: (NSMutableArray *)i {
    
    status3= i;
}

// return the data from former method
- (NSMutableArray *) get3 {
    // if it is a empty array, initialize it
    if (status3==NULL) {
        return [[NSMutableArray alloc] init];
    }
    // if not return the array
    else{
        return status3;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Modules"];
    // set the value from former method to mutable array dic
    dic= [self get3];
    // change the view
    dvc=[[DailyTableViewController alloc] initWithStyle:UITableViewStylePlain];
    // define a done button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(newTo)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [rightButton release];
}

// when the done button been clicked, then change to a new view
-(void)newTo{
    // define the new view. And set it to a modal view
    wvController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    [wvController setDelegate1:self];
    myNavigation1=[[UINavigationController alloc] initWithRootViewController:wvController];
    myNavigation1.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:myNavigation1 animated:YES];
    // store the selected array to WelcomeViewController
    [wvController set:dic];     
    [myNavigation1 release];
    [wvController release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myCustomiseView count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // define the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    // if the module is in selected array then this cell needs to be checked
    id key=[[myCustomiseView allKeys] objectAtIndex:[indexPath row]];
    
    NSMutableDictionary *aaa=[myCustomiseView objectForKey:key];
    [[cell textLabel]setText:[aaa objectForKey:@"moduleCode"]];
    [[cell detailTextLabel]setText:[aaa objectForKey:@"moduleTitle"]];
    NSLog(@"new dic is %@",[self get3]);
    for (int i=0; i<[[self get3] count]; i++) {
        NSString *str=[[self get3] objectAtIndex:i];
        if([[aaa objectForKey:@"moduleCode"] isEqualToString:str]){
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }  
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    id key=[[myCustomiseView allKeys] objectAtIndex:[indexPath row]];
    
    NSMutableDictionary *aaa=[myCustomiseView objectForKey:key];
    
    // when the cell is clicked, then add a check mark
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        // add the checked module to selected array
        [dic addObject:[aaa objectForKey: @"moduleCode"]];

    }
    else{
        // if it already been checked, then remove the check mark when it is clicked 
        newCell.accessoryType = UITableViewCellAccessoryNone;
        // remove the module from the selected array
        [dic removeObject:[aaa objectForKey: @"moduleCode"]];
    }

    
   // UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:indexPath];
//    if (newCell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        newCell.accessoryType = UITableViewCellAccessoryNone;
//    }
}

@end
