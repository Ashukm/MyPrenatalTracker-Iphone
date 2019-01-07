//
//  AARDetailCycleViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/13/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARDetailCycleViewController.h"

@interface AARDetailCycleViewController ()
{
    BOOL viewDidLoad;
    NSArray* pickerViewData;
    NSInteger status;
}
@end

@implementation AARDetailCycleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)setDetailCycle:(AARCycle *)detailCycle
{
    _detailCycle = detailCycle;
    
    if(viewDidLoad)
        [self displayCycleDetails];
    else
        {
            
            if(self.interfaceOrientation == UIDeviceOrientationPortrait)
            {
                //self.mainScrollview.frame = CGRectMake(29, 80, 283, 438);
                self.mainScrollview.contentSize = CGSizeMake(283, 438);
            }
            else
            {
                //self.mainScrollview.frame = CGRectMake(29, 80, 438, 283);
                self.mainScrollview.contentSize = CGSizeMake(283, 450);
                
            }
            
        }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    viewDidLoad = YES;
    
  
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side3.jpg"]];
    
       
    [self initializePickerViewData];
    [self displayCycleDetails];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait)
    {
        self.mainScrollview.frame = CGRectMake(29, 80, 283, 438);
        self.mainScrollview.contentSize = CGSizeMake(283, 438);
    }
    else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.mainScrollview.frame = CGRectMake(29, 80, 438, 283);
        self.mainScrollview.contentSize = CGSizeMake(283, 450);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:OVULATION_DATE_SEGUE])
    {
        [[segue destinationViewController]setMode:EDIT_CYCLE_MODE];
        [[segue destinationViewController]setDateMode:CYCLE_OVULATION_DATE_MODE];
        
        if(_detailCycle.startDate)
        {
            [[segue destinationViewController]setMinPickerDate:_detailCycle.startDate];
        }
        if(_detailCycle.endDate)
        {
            [[segue destinationViewController]setMaxPickerDate:_detailCycle.endDate];
        }
        
        if(_detailCycle.ovulationDate)
        {
            [[segue destinationViewController]setInitialDate:_detailCycle.ovulationDate];
        }
        ((AARDatePickerViewController*)segue.destinationViewController).delegate = self;
    }
}

#pragma -mark private methods
-(void)displayCycleDetails
{
    self.errorLabel.hidden = YES;
    self.saveSuccesLabel.hidden = YES;
    
    if(_detailCycle)
    {
        if(_detailCycle.startDate)
            self.startDateLabel.text = [self cycleDateString:_detailCycle.startDate];
        else
            self.startDateLabel.text = NOT_SET_STRING;
        
        if(_detailCycle.endDate)
            self.endDateLabel.text = [self cycleDateString:_detailCycle.endDate];
        else
            self.endDateLabel.text = NOT_SET_STRING;
        
        if(_detailCycle.ovulationDate)
        {
            [self setButtonLabel:self.ovulationDateLabel buttonTitle:[self cycleDateString:_detailCycle.ovulationDate]];
        }
        else
        {
            [self setButtonLabel:self.ovulationDateLabel buttonTitle:NOT_SET_STRING];
        }
        self.lengthLabel.text =  [NSString stringWithFormat:@"%d",_detailCycle.length];
        
        [self.statusPicker selectRow:_detailCycle.cycleStatus inComponent:0 animated:YES];
        
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

#pragma -mark delegate
-(void)datePickerSelectedDate:(NSDate *)date mode:(NSInteger)mode dateMode:(NSInteger)dateMode
{
    if(dateMode == CYCLE_OVULATION_DATE_MODE)
    {
        _detailCycle.ovulationDate = date;
       [self setButtonLabel:self.ovulationDateLabel buttonTitle:
        [self cycleDateString:_detailCycle.ovulationDate]];
        
        
    }
}

#pragma -mark UI Actions
- (IBAction)saveButtonClicked:(id)sender {
    
    if (_detailCycle)
    {
        _detailCycle.cycleStatus = status;
        if([_detailCycle updateOvulationStatus])
        {
            self.errorLabel.hidden = YES;
            self.saveSuccesLabel.hidden = NO;
            
            if(self.delegate)
                [self.delegate updateCurrentCycle:_detailCycle];
        }
        else
        {
            self.errorLabel.hidden = NO;
            self.saveSuccesLabel.hidden = YES;
        }
        
    }
}

#pragma -mark helper functions
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




@end
