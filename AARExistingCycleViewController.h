//
//  AARExistingCycleViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARDatePickerDelegate.h"
#import "AARDatePickerViewController.h"

#define NEW_CYCLE_START_DATE_SEGUE @"newCycleStartDateSegue"
#define NEW_CYCLE_END_DATE_SEGUE @"newCycleEndDateSegue"
#define NEW_CYCLE_OVULATION_DATE_SEGUE @"newCycleOvulationDateSegue"

#define NOT_SET_TITLE @"Not Set"

@interface AARExistingCycleViewController : UIViewController<AARDatePickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray* pickerViewData;
    AARCycle *cycle;
    NSInteger status;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic)AARCycle *detailCycle;
@property BOOL removNewViewController;

@property (weak, nonatomic) IBOutlet UILabel *sucessLabel;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property  (nonatomic) NSDate *currentNewCycleStartDate;
@property  (nonatomic) NSDate *currentNewCycleEndDate;
@property  (nonatomic) NSDate *currentnewCycleOvulationDate;
@property (weak, nonatomic) IBOutlet UIButton *endDatebutton;
@property (weak, nonatomic) IBOutlet UIButton *ovulationDatebutton;

@property (nonatomic)AARCycle* currentCycle;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;

@property (weak, nonatomic) IBOutlet UILabel *lengthSliderLabel;
- (IBAction)lengthSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *cycleStatusPicker;
@property (weak, nonatomic) IBOutlet UISlider *cycleLengthSlider;
- (IBAction)addCycleButtonClicked:(UIButton *)sender;
@end
