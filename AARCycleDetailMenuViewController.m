//
//  AARCycleDetailMenuViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARCycleDetailMenuViewController.h"

#import "AARChartMenuViewController.h"
#import "AARCalendarCollectionViewController.h"
#import "AARDetailCycleViewController.h"

@interface AARCycleDetailMenuViewController ()

@end

@implementation AARCycleDetailMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    [self setSectionTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:CYCLE_CHART_FROM_MENU_SEGUE])
    {
        [segue.destinationViewController setChartMenuCycle:_detailMenucycle];
    }
    else if([segue.identifier isEqualToString:CYCLE_CALENDAR_FROM_MENU_SEGUE])
    {
        [segue.destinationViewController setCalendarCycle:_detailMenucycle];
    }
    else if([segue.identifier isEqualToString:CYCLE_DETAIL_FROM_MENU_SEGUE])
    {
        [segue.destinationViewController setDetailCycle:_detailMenucycle];
          ((AARCycleDetailMenuViewController*)segue.destinationViewController).delegate = self.delegate;
        
    }
}

#pragma -mark helper functions
-(void)setSectionTitle
{
    if(_detailMenucycle)
    {
        NSString *startDateString = [self cycleDateString:_detailMenucycle.startDate];
        NSString *endEndString = [self cycleDateString:_detailMenucycle.endDate];
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
        
        self.cycleDateLabel.text = labelString;
    }

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


@end
