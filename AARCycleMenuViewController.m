//
//  AARCycleMenuViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/9/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARCycleMenuViewController.h"



#define CURRENT_CYCLE_SUBTITLE @"Current Cycle"
#define EMPTY_STRING @""
#define DELETE_CONFIRM_MESSAGE @"Do you really want to delete cycle?"
#define CANCEL_BUTTON_TITLE @"Cancel"
#define CONFIRM_BUTON_TITLE @"Delete"

@interface AARCycleMenuViewController ()
{
    UIAlertView *deleteAlert;
    NSIndexPath* deleteIndex;
}
@end

@implementation AARCycleMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    NSArray *tempCycles = [AARCycle getAllCycles];
    
    if(tempCycles)
    {
        NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    
        allCycles = [tempCycles sortedArrayUsingDescriptors:@[sortByDate]];
    }
    else
        allCycles = NULL;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(allCycles)
    {
        return allCycles.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CycleCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    AARCycleMenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell)
        cell= [[AARCycleMenuTableViewCell alloc]init];
    

        
    // Configure the cell...
    AARCycle *cycle = (AARCycle*)allCycles[indexPath.row];
    
    NSString *startDateString = [self cycleDateString:cycle.startDate];
    NSString *endEndString = [self cycleDateString:cycle.endDate];
    NSString *labelString = NULL;
    if(endEndString)
    {
        NSString *tempString = [startDateString stringByAppendingString:@"-"];
        labelString = [tempString stringByAppendingString:endEndString];
        
    }
    else
    {
        labelString = startDateString;
    }
    cell.cellTitleLabel.text = labelString;
    
    if(cycle.cycleTimeStatus == CURRENT)
    {
        cell.cellSubTitleLabel.text = CURRENT_CYCLE_SUBTITLE;
    }
    else
    {
        cell.cellSubTitleLabel.text = EMPTY_STRING;
    }
    
    return cell;
}

-(NSString*)cycleDateString:(NSDate *)cycleDate
{
    if(cycleDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        
        return [dateFormatter stringFromDate:cycleDate];
    }
    return NULL;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:CYCLE_DETAIL_MENU_SEGUE])
    {
        NSIndexPath* selectedIndex = self.cycleTableView.indexPathForSelectedRow;
        [[segue destinationViewController]setDetailMenucycle:allCycles[selectedIndex.row]];
        
        AARCycle* cycle = (AARCycle*)allCycles[selectedIndex.row];
        
        if( cycle.cycleTimeStatus == CURRENT)
            ((AARCycleDetailMenuViewController*)segue.destinationViewController).delegate = self.delegate;
        
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       
        deleteIndex = indexPath;
        [self deleteCycleAtIndex:indexPath];
        
            }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)deleteCycleAtIndex:(NSIndexPath*)indexPath
{
    deleteAlert = [[UIAlertView    alloc]initWithTitle:DELETE_CONFIRM_MESSAGE message:EMPTY_STRING delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:CONFIRM_BUTON_TITLE, nil];
    
    [deleteAlert show];
    
  
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
  if(buttonIndex == alertView.cancelButtonIndex)
      return;
   
   
    if([AARCycle deleteCycle:allCycles[deleteIndex.row]])
    {
        allCycles = [AARCycle getAllCycles];
        [self.cycleTableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
