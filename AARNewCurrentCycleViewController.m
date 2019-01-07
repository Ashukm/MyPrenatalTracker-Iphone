//
//  AARNewCurrentCycleViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/12/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARNewCurrentCycleViewController.h"

@interface AARNewCurrentCycleViewController ()
{
    BOOL startDateUserInteraction;
    BOOL viewdidLoad;
}
@end

@implementation AARNewCurrentCycleViewController

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
    viewdidLoad = YES;
    
    [self displayStartDate];
    [self initializePickerViewData];
    
       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side3.jpg"]];
    
    /*
     NSLog(@" x = %f ,  y = %f , width = %f , height = %f" , self.mainScrollView.frame.origin.x,self.mainScrollView.frame.origin.y,self.mainScrollView.frame.size.width ,  self.mainScrollView.frame.size.height);
     NSLog(@"content hight = %f width = %f",self.mainScrollView.contentSize.height ,self.mainScrollView.contentSize.width);*/
   
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 277, 445);
        self.mainScrollView.contentSize = CGSizeMake(277, 445);
    }
    else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 445, 277);
        self.mainScrollView.contentSize = CGSizeMake(277, 455);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCurrentCycle:(AARCycle *)currentCycle
{
    _currentCycle = currentCycle;
    
    if(_currentCycle)
        [self curentCycleFromToday:NO];
    else
        [self curentCycleFromToday:YES];
    
    if(viewdidLoad)
    {
          [self displayStartDate];
    }
    else
    {
        
        if(self.interfaceOrientation == UIDeviceOrientationPortrait)
        {
            //self.mainScrollview.frame = CGRectMake(29, 80, 283, 438);
            self.mainScrollView.contentSize = CGSizeMake(277, 445);
        }
        else
        {
            //self.mainScrollview.frame = CGRectMake(29, 80, 438, 283);
            self.mainScrollView.contentSize = CGSizeMake(277, 445);
            
        }
        
    }
    
}
-(void)setCurrentNewCycleStartDate:(NSDate *)currentNewCycleStartDate
{
    _currentNewCycleStartDate = currentNewCycleStartDate;
    NSString *startDateString = [self cycleDateString:currentNewCycleStartDate];
    [self setButtonLabel:self.startDateButton buttonTitle:startDateString];
    
    NSInteger cycleLength = [self calculateCycleLength:currentNewCycleStartDate endDate:self.currentNewCycleEndDate];
    if(cycleLength < 0)
    {
        //error
    }
    else
    {
        self.cycleLengthSlider.value = cycleLength;
        if(self.currentNewCycleEndDate)
        {
            [self changeCycleEndDate:cycleLength];
        }
    }
}

-(void)setCycleEndDate:(NSDate *)cycleEndDate
{
    [self changeEndDateValue:cycleEndDate];
    
    NSInteger cycleLength = [self calculateCycleLength:self.currentNewCycleStartDate endDate:cycleEndDate];
    if(cycleLength < 0)
    {
        //error
    }
    else
    {
        self.cycleLengthSlider.value = cycleLength;
    }
}

-(void)setCycleOvulationDate:(NSDate *)cycleOvulationDate
{
    _currentnewCycleOvulationDate = cycleOvulationDate;
    NSString *ovulationDateString = [self cycleDateString:cycleOvulationDate];
    [self setButtonLabel:self.ovulationDatebutton buttonTitle:ovulationDateString];
}

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



#pragma -mark Private methods

-(void)curentCycleFromToday:(BOOL)userInteraction
{   
    [self startDayAsToday];
    startDateUserInteraction = userInteraction;
}

-(void)startDayAsToday
{
    NSDate *longToday = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:longToday];
    
    NSDate *today = [calendar dateFromComponents:components];
    
    _currentNewCycleStartDate = today;
    
    [self setButtonLabel:self.startDateButton buttonTitle:[self cycleDateString:today]];
}

-(void)displayStartDate
{
    [self setButtonLabel:self.startDateButton buttonTitle:[self cycleDateString:_currentNewCycleStartDate]];
    
    self.startDateButton.userInteractionEnabled = startDateUserInteraction;
    
    self.errorLabel.hidden = YES;
}


-(BOOL)addCycle
{
    if(self.currentNewCycleStartDate)
    {
        if([self updateCurrentCycle])
        {
        
            
            cycle = [[AARCycle alloc]initWithStartDate:self.currentNewCycleStartDate];
            cycle.endDate = self.currentNewCycleEndDate;
            cycle.ovulationDate = self.currentnewCycleOvulationDate;
            cycle.length = self.cycleLengthSlider.value;
            cycle.cycleStatus = status;
            
            //check for current status
            
            if([cycle addCycle])
            {
                return [AARCycleDay updateDayCycle:cycle.ID date:cycle.startDate];

            }
        }
        
    }
    
    cycle = NULL;
    return NO;
}

-(BOOL)updateCurrentCycle
{
    if(_currentCycle)
    {
        NSDate *longToday = [NSDate date];
      
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:longToday];
        
        NSDate *today = [calendar dateFromComponents:components];
        
        NSDateComponents *yestComponents = [[NSDateComponents alloc]init];
        yestComponents.day = -1;
        
        NSDate *yest = [calendar dateByAddingComponents:yestComponents toDate:today options:0];
        
        _currentCycle.endDate = yest;
        _currentCycle.length = [self calculateCycleLength:_currentCycle.startDate endDate:_currentCycle.endDate] + 1;
        
        return [_currentCycle updateCycle];
       
    }
    return YES;
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



#pragma -mark UI Actions
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
        [self.delegate updateCurrentCycle:cycle];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        self.errorLabel.hidden = NO;
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


#pragma -mark Helper Methods

-(NSString*)cycleDateString:(NSDate *)cycleDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    return [dateFormatter stringFromDate:cycleDate];
}

-(void)setButtonLabel:(UIButton*)button buttonTitle:(NSString*)buttonTitle
{
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateReserved];
    [button setTitle:buttonTitle forState:UIControlStateSelected];
    [button setTitle:buttonTitle forState:UIControlStateHighlighted];
    [button setTitle:buttonTitle forState:UIControlStateDisabled];
}

-(void)initializePickerViewData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"CycleStatusList" ofType:@"plist"];
    pickerViewData  = [[NSArray alloc]initWithContentsOfFile:plistPath];
    status = 0;
}

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


@end
