//
//  AARDatePickerViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/6/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARDatePickerDelegate.h"


#define NEW_CYCLE_TITLE @"New Cycle"
#define EDIT_CYCLE_TITLE @"Edit Cycle"

#define CYCLE_START_DATE_LABEL @"Cycle Start Date"
#define CYCLE_END_DATE_LABEL @"Cycle End Date"
#define CYCLE_OVULATION_DATE_LABEL @"Ovulation Date"


#define NEW_CYCLE_START_DATE_SEGUE @"newCycleStartDateSegue"
#define NEW_CYCLE_END_DATE_SEGUE @"newCycleEndDateSegue"
#define NEW_CYCLE_OVULATION_DATE_SEGUE @"newCycleOvulationDateSegue"
#define NEW_CYCLE_ADDED_SEGUE @"cycleAddedSegue"

#define NEW_CYCLE_MODE 0
#define EDIT_CYCLE_MODE 1
#define CYCLE_START_DATE_MODE 0
#define CYCLE_END_DATE_MODE 1
#define CYCLE_OVULATION_DATE_MODE 2

@interface AARDatePickerViewController : UIViewController
{
       BOOL cancel;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSInteger mode;
@property NSInteger dateMode;
@property NSDate* initialDate;
@property NSDate* maxPickerDate;
@property NSDate* minPickerDate;


@property  id<AARDatePickerDelegate> delegate;

- (IBAction)doneOnBarClicked:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
