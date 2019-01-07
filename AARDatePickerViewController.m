//
//  AARDatePickerViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/6/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARDatePickerViewController.h"


@interface AARDatePickerViewController ()
{
  
}
@end

@implementation AARDatePickerViewController

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
    
    cancel = NO;
    
    if(self.initialDate)
    {
        self.datePicker.date = self.initialDate;
    }
    if(self.maxPickerDate)
    {
        self.datePicker.maximumDate = self.maxPickerDate;
    }
    if(self.minPickerDate)
    {
        self.datePicker.minimumDate = self.minPickerDate;
    }
    
    if(self.mode == NEW_CYCLE_MODE)
    {
        self.navigationItem.title = NEW_CYCLE_TITLE;
    }
    else
    {
        self.navigationItem.title = EDIT_CYCLE_TITLE;
    }
    
    if(self.dateMode == CYCLE_START_DATE_MODE)
    {
        self.titleLabel.text = CYCLE_START_DATE_LABEL;
    }
    else if(self.dateMode == CYCLE_END_DATE_MODE)
    {
        self.titleLabel.text = CYCLE_END_DATE_LABEL;
    }
    else if(self.dateMode == CYCLE_OVULATION_DATE_MODE)
    {
        self.titleLabel.text = CYCLE_OVULATION_DATE_LABEL;
    }
    
      // self.navigationItem.rightBarButtonItem = self.;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side3.jpg"]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneOnBarClicked:(UIBarButtonItem *)sender {
    
    [self.delegate datePickerSelectedDate:self.datePicker.date mode:self.mode dateMode:self.dateMode];
    [self.navigationController popViewControllerAnimated:YES];
    
}





@end
