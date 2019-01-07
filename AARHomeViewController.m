//
//  AARHomeViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/6/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARHomeViewController.h"
#import "AARChartMenuViewController.h"
#import "AARCalendarCollectionViewController.h"
#import "AARDetailDayViewController.h"
#import "AARNewCurrentCycleViewController.h"
#import "AARDetailCycleViewController.h"
#import "AARMainMenuTableViewController.h"

@interface AARHomeViewController ()
{
    AARCycleDay *todayCycleDay;
    NSInteger dayIndex;
}
@end

@implementation AARHomeViewController

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
    
    [self displayCurrentcycle];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side2.jpg"]];
    
    self.mainScrollView.contentSize = CGSizeMake(203, 438);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
  
    [self.mainScrollView addGestureRecognizer:tapRecognizer];
    
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait)
    {
        self.mainScrollView.frame = CGRectMake(97, 40, 203, 438);
        self.mainScrollView.contentSize = CGSizeMake(203, 438);
    }
    else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.mainScrollView.frame = CGRectMake(97, 40, 203, 238);
        self.mainScrollView.contentSize = CGSizeMake(203, 438);
    }
}

-(BOOL)shouldAutorotate
{
    return  YES;
}

-(void)displayCurrentcycle
{
    //Get the current cycle
    homeCycle = [AARCycle getCurrentCycle];
    
    
    
    [self displayCycleDetails];
    
    
    self.saveMessageLabel.text = EMPTY_STRING;
}

-(void)displayCycleDetails
{
    NSString *todayDateString = [self cycleDateString:[NSDate date]];
    if(todayDateString)
        self.todayDateLabel.text = todayDateString;

    if(homeCycle)
    {
        
        UIColor * blueAppColor = [UIColor colorWithRed:138.0/255.0 green:211.0/255.0 blue:344.0/255.0 alpha:1.0];
        
        UIColor * pinkAppColor = [UIColor colorWithRed:249.0/255.0 green:195.0/255.0 blue:208.0/255.0 alpha:1.0];

        self.todayDateLabel.backgroundColor = blueAppColor;
        self.todayDateLabel.textColor = [UIColor whiteColor];
        
        [self.todayView setUserInteractionEnabled:YES];
        NSString *startDateString = [self cycleDateString:homeCycle.startDate];
        if(startDateString)
            self.currentCycleStartDateLabel.text = startDateString;
        
        todayCycleDay = [self todayDayFromCycleDays];
        [self displayTodayData];
        
        [self.chartButton setEnabled:YES];
        self.chartButton.tintColor = pinkAppColor;
        
        [self.calendarButton setEnabled:YES];
        self.calendarButton.tintColor = pinkAppColor;
        
        [self.detailCycleButton setEnabled:YES];
        self.detailCycleButton.tintColor = pinkAppColor;
        
        self.moreButton.tintColor = pinkAppColor;
        self.saveButton.backgroundColor = pinkAppColor;
        
    }
    else
    {
        self.todayDateLabel.backgroundColor = [UIColor whiteColor];
         self.todayDateLabel.textColor = [UIColor grayColor];
        
        [self.todayView setUserInteractionEnabled:NO];
        self.currentCycleStartDateLabel.text = NOT_SET_STRING;
        self.todayBBTTextField.text = EMPTY_STRING;
        
               
        [self.chartButton setEnabled:NO];
        self.chartButton.tintColor = [UIColor grayColor];
        
        [self.calendarButton setEnabled:NO];
        self.calendarButton.tintColor = [UIColor grayColor];
        
        [self.detailCycleButton setEnabled:NO];
        self.detailCycleButton.tintColor = [UIColor grayColor];
        
        self.moreButton.tintColor = [UIColor grayColor];
        self.saveButton.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}

-(void)displayTodayData
{

    
    if(todayCycleDay)
    {
        self.todayBBTTextField.text = [NSString stringWithFormat:@"%0.2f",todayCycleDay.bbt];
        
        if(todayCycleDay.ovulationTest == 0)
        {
            self.todayOvulationSwitch.on = NO;
            self.ovulationSwitchResultLabel.text = NEGATIVE_STRING;
        }
        else if(todayCycleDay.ovulationTest == 1)
        {
            self.todayOvulationSwitch.on = YES;
            self.ovulationSwitchResultLabel.text = POSITIVE_STRING;
        }
        else
        {
            self.todayOvulationSwitch.on = NO;
            self.ovulationSwitchResultLabel.text = NEGATIVE_STRING;
        }
    }

}


-(AARCycleDay*)todayDayFromCycleDays
{
    NSDate *longToday = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:longToday];
    
    NSDate *today = [calendar dateFromComponents:components];
    
    dayIndex = 0;
    
    for (AARCycleDay* day in homeCycle.cycleDays) {
        
        dayIndex++;
        if([day.date compare:today] == NSOrderedSame)
        {
            return day;
        }
    }
    
    return NULL;
    
}

-(void)updateCurrentCycle:(AARCycle *)currentCycle
{
    homeCycle = currentCycle;
    [self displayCycleDetails];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if([segue.identifier isEqualToString:CHART_MENU_SEGUE])
    {
        [segue.destinationViewController setChartMenuCycle:homeCycle];
    }
    else if([segue.identifier isEqualToString:CALENDAR_SEGUE])
    {
        [segue.destinationViewController setCalendarCycle:homeCycle];
    }
    else if([segue.identifier isEqualToString:MORE_DAY_DETAILS_SEGUE])
    {
        [segue.destinationViewController setCycleDay:dayIndex];
        [segue.destinationViewController setDetailDay:todayCycleDay];
        ((AARDetailDayViewController*)segue.destinationViewController).delegate = self;

    }
    else if ([segue.identifier isEqualToString:NEW_CYCLE_SEGUE])
    {
        ((AARNewCurrentCycleViewController*)segue.destinationViewController).delegate = self;
        [segue.destinationViewController setCurrentCycle:homeCycle];
    }
    else if([segue.identifier isEqualToString:DETAIL_CYCLE_VIEW_SEGUE])
    {
        [segue.destinationViewController setDetailCycle:homeCycle];
       
    }
    else if([segue.identifier isEqualToString:MAIN_MENU_SEGUE])
    {
        [segue.destinationViewController setMainMenuCycle:homeCycle];
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [self.todayBBTTextField resignFirstResponder];
}



#pragma mark UI Actions

- (IBAction)todayOvulationSwitchValueChanged:(UISwitch *)sender
{
    if(self.todayOvulationSwitch.on)
    {
        self.ovulationSwitchResultLabel.text = POSITIVE_STRING;
        todayCycleDay.ovulationTest = 1;
    }
    else
    {
        self.ovulationSwitchResultLabel.text = NEGATIVE_STRING;
        todayCycleDay.ovulationTest= 0;
    }
}

- (IBAction)todayDetailsSave:(UIButton *)sender {
    
    todayCycleDay.bbt = [self.todayBBTTextField.text floatValue];
    
   
    
    if([todayCycleDay updateCycleDay])
    {
        self.saveMessageLabel.textColor = sender.titleLabel.textColor;
        self.saveMessageLabel.text = SAVE_SUCCESS_STRING;
    }
    else
    {
        self.saveMessageLabel.textColor = [UIColor redColor];
        self.saveMessageLabel.text = SAVE_ERROR_STRING;
    }
}

#pragma -mark cycle day delegate
-(void)cycleDayChanged:(AARCycleDay *)newCycleDay
{
    [self displayTodayData];
}


#pragma -mark Helpr Functions
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
