//
//  AARExistingCycleViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARExistingCycleViewController.h"



@interface AARExistingCycleViewController ()

@end

@implementation AARExistingCycleViewController

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
    
    
    self.sucessLabel.hidden = YES;
    self.errorLabel.hidden = YES;
    
    [self initializePickerViewData];
  
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side3.jpg"]];
    
    

}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 203, 438);
        self.mainScrollView.contentSize = CGSizeMake(281, 485);
    }
    else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 438, 438);
        self.mainScrollView.contentSize = CGSizeMake(281, 550);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)addCycle
{
    if(self.currentNewCycleStartDate)
    {
        cycle = [[AARCycle alloc]initWithStartDate:self.currentNewCycleStartDate];
        cycle.endDate = self.currentNewCycleEndDate;
        cycle.ovulationDate = self.currentnewCycleOvulationDate;
        cycle.length = self.cycleLengthSlider.value;
        cycle.cycleStatus = status;
        
        //check for current status
        
        return [cycle addPreviousCycle];
    }
    
    cycle = NULL;
    return NO;
}


#pragma -mark UIActions
- (IBAction)lengthSliderChanged:(id)sender {
    
    UISlider * senderSlider = (UISlider*)sender;
    if(senderSlider.value > 0)
    {
        [self changeCycleEndDate:senderSlider.value];
    }
    else
    {
        self.lengthSliderLabel.text = NOT_SET_TITLE;
    }
    
}

- (IBAction)addCycleButtonClicked:(UIButton *)sender {
    
    
    if([self addCycle])
    {
        //call delegate
        self.errorLabel.hidden = YES;
        self.sucessLabel.hidden = NO;
        
      //  [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        self.errorLabel.hidden = NO;
        self.sucessLabel.hidden = YES;
    }
    
}

#pragma -mark Segue Functions
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:NEW_CYCLE_START_DATE_SEGUE])
    {
        [[segue destinationViewController]setMode:NEW_CYCLE_MODE];
        [[segue destinationViewController]setDateMode:CYCLE_START_DATE_MODE];
        
        [[segue destinationViewController]setMaxPickerDate:[NSDate date]];
        
        if(self.currentNewCycleStartDate)
        {
            [[segue destinationViewController]setInitialDate:self.currentNewCycleStartDate];
        }
        ((AARDatePickerViewController*)segue.destinationViewController).delegate = self;
    }
    else if([[segue identifier] isEqualToString:NEW_CYCLE_END_DATE_SEGUE])
    {
        [[segue destinationViewController]setMode:NEW_CYCLE_MODE];
        [[segue destinationViewController]setDateMode:CYCLE_END_DATE_MODE];
        
        
        if(self.currentnewCycleOvulationDate)
        {
            [[segue destinationViewController]setMinPickerDate:self.currentnewCycleOvulationDate];
        }
        else if(self.currentNewCycleStartDate)
        {
            [[segue destinationViewController]setMinPickerDate:self.currentNewCycleStartDate];
        }
        if(self.currentNewCycleEndDate)
        {
            [[segue destinationViewController]setInitialDate:self.currentNewCycleEndDate];
        }
        ((AARDatePickerViewController*)segue.destinationViewController).delegate = self;
        
    }
    else if([[segue identifier] isEqualToString:NEW_CYCLE_OVULATION_DATE_SEGUE])
    {
        [[segue destinationViewController]setMode:NEW_CYCLE_MODE];
        [[segue destinationViewController]setDateMode:CYCLE_OVULATION_DATE_MODE];
        
        if(self.currentNewCycleStartDate)
        {
            [[segue destinationViewController]setMinPickerDate:self.currentNewCycleStartDate];
        }
        if(self.currentNewCycleEndDate)
        {
            [[segue destinationViewController]setMaxPickerDate:self.currentNewCycleEndDate];
        }
        
        if(self.currentnewCycleOvulationDate)
        {
            [[segue destinationViewController]setInitialDate:self.currentnewCycleOvulationDate];
        }
        ((AARDatePickerViewController*)segue.destinationViewController).delegate = self;
    }
    

}


#pragma -mark UIPicker View Datasource , Delegate Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerViewData.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerViewData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    status = row;
}


#pragma -mark delegate methods
-(void)datePickerSelectedDate:(NSDate *)date mode:(NSInteger)mode dateMode:(NSInteger)dateMode
{
    switch (dateMode) {
        case CYCLE_START_DATE_MODE:
            _currentNewCycleStartDate = date;
            [self setButtonLabel:self.startDateButton buttonTitle:[self cycleDateString:_currentNewCycleStartDate]];
            break;
        case CYCLE_END_DATE_MODE:
            _currentNewCycleEndDate = date;
            [self setButtonLabel:self.endDatebutton buttonTitle:[self cycleDateString:_currentNewCycleEndDate]];
            
            NSInteger cycleLength = [self calculateCycleLength:self.currentNewCycleStartDate endDate:self.currentNewCycleEndDate];
            if(cycleLength < 0)
            {
                //error
            }
            else
            {
                self.cycleLengthSlider.value = cycleLength;
                self.lengthSliderLabel.text = [NSString stringWithFormat:@"%d",cycleLength];
            }
            
            break;
        case CYCLE_OVULATION_DATE_MODE:
            _currentnewCycleOvulationDate = date;
            [self setButtonLabel:self.ovulationDatebutton buttonTitle:[self cycleDateString:_currentnewCycleOvulationDate]];
            break;
        default:
            break;
    }
}

#pragma -mark Helper Functions

-(NSInteger)calculateCycleLength:(NSDate*)startDate endDate:(NSDate*)endDate
{
    if(startDate == nil || endDate == nil)
    {
        return 0;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    return components.day;
}


-(void)removeNewViewControllerFromStack
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    [viewControllers removeObjectAtIndex:viewControllers.count-2];
    
    self.navigationController.viewControllers = viewControllers;
}

-(NSString*)cycleDateString:(NSDate *)cycleDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    return [dateFormatter stringFromDate:cycleDate];
}

-(void)displayCycleData
{
     NSString *startDateString =[self cycleDateString:self.detailCycle.startDate];
    
    [self setButtonLabel:self.startDateButton buttonTitle:startDateString];
}

-(void)setButtonLabel:(UIButton*)button buttonTitle:(NSString*)buttonTitle
{
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateReserved];
    [button setTitle:buttonTitle forState:UIControlStateSelected];
    [button setTitle:buttonTitle forState:UIControlStateHighlighted];
    [button setTitle:buttonTitle forState:UIControlStateDisabled];
}

-(void)changeCycleEndDate:(float)cycleLength
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    
    dateComponents.day = cycleLength - 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    self.lengthSliderLabel.text = [NSString stringWithFormat:@"%1.0f",cycleLength];
    
    if(self.currentNewCycleStartDate)
    {
        NSDate* newEndDate = [calendar dateByAddingComponents:dateComponents toDate:self.currentNewCycleStartDate options:0];
        [self changeEndDateValue:newEndDate];
    }
}

-(void)changeEndDateValue:(NSDate*)endDate
{
    _currentNewCycleEndDate = endDate;
    NSString *endDateString = [self cycleDateString:endDate];
    [self setButtonLabel:self.endDatebutton buttonTitle:endDateString];
    
}

-(void)initializePickerViewData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"CycleStatusList" ofType:@"plist"];
    pickerViewData  = [[NSArray alloc]initWithContentsOfFile:plistPath];
    status = 0;
}
@end
