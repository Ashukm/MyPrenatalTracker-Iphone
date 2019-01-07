//
//  AARDetailDayViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/11/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARCycleDayDelegate.h"

#define NEGATIVE_STRING @"Negative"
#define POSITIVE_STRING @"Positive"
#define VERY_FAINT_POSITIVE @"Very Faint Positive"
#define FAINT_POSITIVE @"Faint Positive"

#define CYCLE_DAY_STRING @"CD"
#define EMPTY_STRING @""

#define YES_STRING @"Yes"
#define NO_STRING @"No"

#define SAVE_ERROR_STRING @"Error in saving details."
#define SAVE_SUCCESS_STRING @"Details saved."

@interface AARDetailDayViewController : UIViewController<UIGestureRecognizerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender;
@property (nonatomic)AARCycleDay* detailDay;
@property (nonatomic)NSInteger cycleDay;

@property  id<AARCycleDayDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *dayTitlelabel;
@property (weak, nonatomic) IBOutlet UITextField *bbtTextField;
@property (weak, nonatomic) IBOutlet UISwitch *ovulationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *intercourseSwitch;
@property (weak, nonatomic) IBOutlet UITextField *progesteroneTextField;
@property (weak, nonatomic) IBOutlet UISlider *pregnancyTestSlider;
@property (weak, nonatomic) IBOutlet UITextField *hcgTextField;
@property (weak, nonatomic) IBOutlet UILabel *pregnancyTestValueLabel;

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *saveStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ovulationTestValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *intercourseValueLabel;

- (IBAction)pregnancyTestSliderValueChanged:(id)sender;
- (IBAction)ovulationTestSwitchValueChanged:(UISwitch *)sender;
- (IBAction)intercourseSwitchValueChanged:(UISwitch *)sender;
- (IBAction)saveCycleButtonClicked:(UIButton *)sender;

@end
