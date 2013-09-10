//
//  DailyTableViewController.m
//  TimeTable
//
//  Created by Xiaoyi Cai on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DailyTableViewController.h"
#import "SBJSON.h"
#import "WelcomeViewController.h"
#import "DetailViewController.h"


@implementation DailyTableViewController

@synthesize dayDetail;
@synthesize myDailyTableCell;

// initialise a new integer which is used later
int a;



// to initiate a new daily table view model
- (void)initDailyTableViewModel{
    
    // initialise the two dictionary
    myDailyTableViewModel = nil;
    semesterModule = nil;
    
    // Generate the URL request for the JSON data
    NSURL *url = [NSURL URLWithString:@"http://www.csc.liv.ac.uk/people/trp/Teaching_Resources/COMP327/TimeTable.json"];
     NSURL *url1 = [NSURL URLWithString:@"http://www.csc.liv.ac.uk/people/trp/Teaching_Resources/COMP327/Semester1Modules.json"];
    
    
    // Get the contents of the URL as a string
    
    NSString *jsonString = [NSString stringWithContentsOfURL:url
                            
                                                    encoding:NSUTF8StringEncoding error:nil];
    
    NSString *jsonString1 = [NSString stringWithContentsOfURL:url1
                            
                                                    encoding:NSUTF8StringEncoding error:nil];
    
    
    if (jsonString) {  
        
        myDailyTableViewModel = [jsonString JSONValue];
        
        [myDailyTableViewModel retain];
        
    }   
    
    if (jsonString1) {
        
        semesterModule = [jsonString1 JSONValue];
        
        [semesterModule retain];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self initDailyTableViewModel];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // to check the day detail which is got from the welcome view controller
    // so we can know which part is needed in the json file
    
    if(dayDetail==@"Monday"){
        a=0;
    }
    if(dayDetail==@"Tuesday"){
        a=1;
    }
    if(dayDetail==@"Wednesday"){
        a=2;
    }
    if(dayDetail==@"Thursday"){
        a=3;
    }
    if(dayDetail==@"Friday"){
        a=4;
    }
    
    // set title of this view 
    [self setTitle:dayDetail];
    // use the nib file to initialize the cell
    [[NSBundle mainBundle] loadNibNamed:@"myDailyTableCell" owner:self options:nil];
    CGRect cellRect = [myDailyTableCell bounds];
    [self setMyDailyTableCell:nil];
    [[self tableView] setRowHeight:cellRect.size.height];

    }

// set the mutable array with the value which is got from WelcomeViewController
-(void) set1: (NSMutableArray *)i {
    
    status1= i;
}

// get the array which is set in former method
- (NSMutableArray *) get1 {
    return status1;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    
    // return the number of section
    // first we define the timetable part in the json file as an array
    NSArray *timetable = [myDailyTableViewModel objectForKey:@"timetable"];
    // get the dictionary of the sepecial day
    NSMutableArray *day = [timetable objectAtIndex:a];
   
    // return the count
    return [day count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count=0;
    NSArray *timetable = [myDailyTableViewModel objectForKey:@"timetable"];
    
    NSArray *day = [timetable objectAtIndex:a];
    // transfer the array day to dictionary day1
    NSDictionary *day1 = [day objectAtIndex:section];
    // use the array to get the content under the key events
    NSArray *event = [day1 objectForKey:@"events"];
    
    // use the loop to check if there are value which is checked by customer in customiseViewController in event array
    for (int i = 0; i<[event count]; i++) {
        // get the module code in json file
        NSDictionary *module = [event objectAtIndex:i];
        NSString *str = [module objectForKey:@"module"];

        // use another loop to see if the module that been selected is in the event array
        for(int j=0; j<[[self get1] count];j++){
            //NSLog(@"str1 is %@",[[self get1] objectAtIndex:j]);
            NSString *str1 = [[self get1] objectAtIndex:j];
            
            if([str isEqualToString:str1]){
                count++;
            }
        }
    }

    return count; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    
   // define the title
    
    NSArray *timetable = [myDailyTableViewModel objectForKey:@"timetable"];
    
    NSArray *day = [timetable objectAtIndex:a];

    NSDictionary *day1 = [day objectAtIndex:section];  
    
    NSMutableArray *event = [day1 objectForKey:@"events"];

    // use loop to find and remove the module which is not been selected
    // so a new event array can be got
    for(int p=0; p<[event count]; p++){
        int count3=0;
        NSDictionary *module = [event objectAtIndex:p];
        NSString *str2= [module objectForKey:@"module"];
        NSLog(@"str2 is %@", str2);
        for (int q=0; q<[[self get1] count]; q++){
            NSString *str3 = [[self get1] objectAtIndex:q];
            NSLog(@"str3 is %@", str3);
            if (![str2 isEqualToString:str3]) {
                count3++;
            }
        }
        //to check how many times it has been failed 
        //to find the correspond module in the select array
        // if it equals to the number of objects in select array, then it will be removed 
        if (count3==[[self get1] count]) {
            [event removeObject:[event objectAtIndex:p]];
        }
    }
    if([event count]!=0){
        return [day1 objectForKey:@"time"];
    }
    else{
        return NULL;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"myDailyTableCell" owner:self options:nil];
        cell = myDailyTableCell;
        [self setMyDailyTableCell:nil];

    }
    

    
    // Configure the cell...
    // same code with before
    NSArray *timetable = [myDailyTableViewModel objectForKey:@"timetable"];
    NSArray *day = [timetable objectAtIndex:a];
    NSDictionary *day1 = [day objectAtIndex:[indexPath section]];
    //NSLog(@"day1111 is %@", day1);
    NSMutableArray *event = [day1 objectForKey:@"events"];
    
   // same with former method
    for(int p=0; p<[event count]; p++){
        int count3=0;
        NSDictionary *module = [event objectAtIndex:p];
        NSString *str2= [module objectForKey:@"module"];
        NSLog(@"str2 is %@", str2);
        for (int q=0; q<[[self get1] count]; q++){
            NSString *str3 = [[self get1] objectAtIndex:q];
            NSLog(@"str3 is %@", str3);
            if (![str2 isEqualToString:str3]) {
                count3++;
            }
        }
        if (count3==[[self get1] count]) {
            [event removeObject:[event objectAtIndex:p]];
        }
    }
    // use the new array to get the detail
    NSDictionary *module = [event objectAtIndex:[indexPath row]];
    NSDictionary *semesmodule = [semesterModule objectForKey:[module objectForKey:@"module"]];


    // define the different labels and image with the tag which is defined in header file
    UILabel *moduleLable = (UILabel *)[cell viewWithTag:MODULELABEL_TAG];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:DESCRIPTIONLABEL_TAG];
    UILabel *placeLabel = (UILabel *)[cell viewWithTag:PLACELABEL_TAG];
    UIImageView *Image = (UIImageView *)[[cell contentView] viewWithTag:IMAGE_TAG];
    
    [moduleLable setText:[module objectForKey:@"module"]];
    [placeLabel setText:[module objectForKey:@"room"]];
    [detailLabel setText:[semesmodule objectForKey:@"moduleTitle"]];
    
    NSString *str = [module objectForKey:@"type"];

    if ([str isEqualToString:@"lecture"]) {
        // define the imagePath
        NSString *ImagePath = [[NSBundle mainBundle] pathForResource:@"137-presentation" ofType:@"png"];
        // define the new image
        UIImage *vImage = [UIImage imageWithContentsOfFile:ImagePath];
        // set the image
        [Image setImage:vImage];
    }
    
    if ([str isEqualToString:@"tutorial"]) {
        NSString *ImagePath = [[NSBundle mainBundle] pathForResource:@"96-book" ofType:@"png"];
        
        UIImage *vImage = [UIImage imageWithContentsOfFile:ImagePath];
        
        [Image setImage:vImage];
        
    }
    
    if([str isEqualToString:@"lab"])  {
        NSString *ImagePath = [[NSBundle mainBundle] pathForResource:@"174-imac" ofType:@"png"];
        
        UIImage *vImage = [UIImage imageWithContentsOfFile:ImagePath];
        
        [Image setImage:vImage];
    }

    
//    // return the new cell
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
    // get the information of the cell which has been selected
    NSArray *timetable = [myDailyTableViewModel objectForKey:@"timetable"];
    NSArray *day = [timetable objectAtIndex:a];
    NSDictionary *day1 = [day objectAtIndex:[indexPath section]];
    NSMutableArray *event = [day1 objectForKey:@"events"];
    // same as before
    for(int p=0; p<[event count]; p++){
        int count3=0;
        NSDictionary *module = [event objectAtIndex:p];
        NSString *str2= [module objectForKey:@"module"];
        //NSLog(@"str2 is %@", str2);
        for (int q=0; q<[[self get1] count]; q++){
            NSString *str3 = [[self get1] objectAtIndex:q];
            //NSLog(@"str3 is %@", str3);
            if (![str2 isEqualToString:str3]) {
                count3++;
            }
        }
        if (count3==[[self get1] count]) {
            [event removeObject:[event objectAtIndex:p]];
        }
    }
    NSDictionary *module = [event objectAtIndex:[indexPath row]];
    NSDictionary *semesmodule = [semesterModule objectForKey:[module objectForKey:@"module"]];
    
        
    
    // Navigation logic may go here. Create and push another view controller.
    
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    // set the module detail which will be used in detail view
    [detailViewController setModuleDetail:semesmodule];

    
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
    
//    DetailViewController *detailViewController= [[DailyTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    
//    NSString *day = [myDataArray objectAtIndex:[indexPath row]];
//    [DailyTableView setDayDetail:day];
//    NSLog(@"Day detail %@", day);
//    
//    [self.navigationController pushViewController:DailyTableView animated:YES];
//    
//    
//    
//    [DailyTableViewController release];
}

@end
