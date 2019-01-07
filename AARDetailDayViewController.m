//
//  AARDetailDayViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/11/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARDetailDayViewController.h"

@interface AARDetailDayViewController ()
{
    BOOL viewLoaded ;
}
@end

@implementation AARDetailDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setDetailDay:(AARCycleDay *)detailDay
{
    _detailDay = detailDay;
    
   if(viewLoaded)
       [self uiFieldsDataDisplay];
    else
    {
        
        if(self.interfaceOrientation == UIDeviceOrientationPortrait)
        {
            self.mainScrollView.frame = CGRectMake(29, 80, 283, 438);
            self.mainScrollView.contentSize = CGSizeMake(283, 438);
        }
        else
        {
            self.mainScrollView.frame = CGRectMake(29, 80, 438, 283);
            self.mainScrollView.contentSize = CGSizeMake(283, 450);

        }

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    viewLoaded = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side3.jpg"]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    
    [self.mainScrollView addGestureRecognizer:tapRecognizer];
    
    /*
    if(self.interfaceOrientation == UIDeviceOrientationPortrait)
        self.mainScrollView.contentSize = CGSizeMake(283, 438);
    else
        self.mainScrollView.contentSize = CGSizeMake(283, 450);*/
    
    [self uiFieldsDataDisplay];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationPortrait)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 283, 438);
         self.mainScrollView.contentSize = CGSizeMake(283, 438);
    }
    else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.mainScrollView.frame = CGRectMake(29, 80, 438, 283);
        self.mainScrollView.contentSize = CGSizeMake(283, 450);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [self.bbtTextField resignFirstResponder];
    [self.progesteroneTextField resignFirstResponder];
    [self.hcgTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
}

-(void)uiFieldsDataDisplay
{
    self.saveStatusLabel.text = EMPTY_STRING;
    
    if(_detailDay)
    {
        NSString *tempString = [CYCLE_DAY_STRING stringByAppendingFormat:@"%d - ",_cycleDay];
        NSString* dateString = [self cycleDateString:_detailDay.date];
        
        self.dayTitlelabel.text = [tempString stringByAppendingString:dateString];
        self.bbtTextField.text = [NSString stringWithFormat:@"%0.2f",_detailDay.bbt];
        self.progesteroneTextField.text = [NSString stringWithFormat:@"%d",_detailDay.progestrone];
        self.weightTextField.text = [NSString stringWithFormat:@"%d",_detailDay.weight];
        self.hcgTextField.text = [NSString stringWithFormat:@"%d",_detailDay.hcg];
        
        if(_detailDay.intercouse)
        {
            self.intercourseSwitch.on = YES;
            self.intercourseValueLabel.text = YES_STRING;
        }
        else
        {
            self.intercourseSwitch.on = NO;
            self.intercourseValueLabel.text = NO_STRING;
        }
        
        if(_detailDay.ovulationTest == 1)
        {
            self.ovulationSwitch.on = YES;
            self.ovulationTestValueLabel.text = POSITIVE_STRING;
        }
        else if(_detailDay.ovulationTest == 0)
        {
            self.ovulationSwitch.on = NO;
            self.ovulationTestValueLabel.text = NEGATIVE_STRING;
        }
        else
        {
            self.ovulationSwitch.on = NO;
            self.ovulationTestValueLabel.text = NEGATIVE_STRING;
        }
        
        switch (_detailDay.prenancyTest) {
            case 0:
                self.pregnancyTestSlider.value = 0.0;
                self.pregnancyTestValueLabel.text = NEGATIVE_STRING;
                break;
            case 1:
                self.pregnancyTestSlider.value = 1.0;
                self.pregnancyTestValueLabel.text = VERY_FAINT_POSITIVE;
                break;
            case 2:
                self.pregnancyTestSlider.value = 2.0;
                self.pregnancyTestValueLabel.text = FAINT_POSITIVE;
                break;
            case 3:
                self.pregnancyTestSlider.value = 1.0;
                self.pregnancyTestValueLabel.text = POSITIVE_STRING;
                break;
            default:
                self.pregnancyTestSlider.value = 0.0;
                self.pregnancyTestValueLabel.text = NEGATIVE_STRING;
                break;
        }
    }
}

#pragma -mark UI Actions

- (IBAction)pregnancyTestSliderValueChanged:(id)sender {
    
    switch ((NSInteger)self.pregnancyTestSlider.value) {
        case 0:
            _detailDay.prenancyTest = 0;
            self.pregnancyTestValueLabel.text = NEGATIVE_STRING;
            break;
        case 1:
            _detailDay.prenancyTest = 1;
            self.pregnancyTestValueLabel.text = VERY_FAINT_POSITIVE;
            break;
        case 2:
            _detailDay.prenancyTest = 2;
            self.pregnancyTestValueLabel.text = FAINT_POSITIVE;
            break;
        case 3:
            _detailDay.prenancyTest = 3;
            self.pregnancyTestValueLabel.text = POSITIVE_STRING;
            break;
        default:
            _detailDay.prenancyTest = 0;
            self.pregnancyTestValueLabel.text = NEGATIVE_STRING;
            break;
    }
}

- (IBAction)ovulationTestSwitchValueChanged:(UISwitch *)sender {
    
    if(self.ovulationSwitch.on == 1)
    {
        _detailDay.ovulationTest = 1;
        self.ovulationTestValueLabel.text = POSITIVE_STRING;
    }
    else if(_detailDay.ovulationTest == 0)
    {
        _detailDay.ovulationTest = 0;
        self.ovulationTestValueLabel.text = NEGATIVE_STRING;
    }
    else
    {
        _detailDay.ovulationTest = 0;
        self.ovulationTestValueLabel.text = NEGATIVE_STRING;
    }

}

- (IBAction)intercourseSwitchValueChanged:(UISwitch *)sender {
    
    if(self.intercourseSwitch.on)
    {
        _detailDay.intercouse = YES;
        self.intercourseValueLabel.text = YES_STRING;
    }
    else
    {
        _detailDay.intercouse = NO;
        self.intercourseValueLabel.text = NO_STRING;
    }

}

- (IBAction)saveCycleButtonClicked:(UIButton *)sender {
    
    _detailDay.bbt = [self.bbtTextField.text floatValue];
    _detailDay.progestrone = [self.progesteroneTextField.text integerValue];
    _detailDay.weight = [self.weightTextField.text integerValue];
    _detailDay.hcg = [self.hcgTextField.text integerValue];
    
    if([_detailDay updateCycleDay])
    {
        self.saveStatusLabel.text = SAVE_SUCCESS_STRING;
        self.saveStatusLabel.textColor = sender.backgroundColor;
        
        if(self.delegate)
            [self.delegate cycleDayChanged:_detailDay];
    }
    else
    {
        self.saveStatusLabel.text = SAVE_ERROR_STRING;
        self.saveStatusLabel.textColor = [UIColor redColor];

    }

}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {

    [self hideKeyboard];
}

#pragma -mark Helper Functions

-(NSString*)cycleDateString:(NSDate *)cycleDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    return [dateFormatter stringFromDate:cycleDate];
}


@end
