//
//  AARDetailCycleViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/13/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARDatePickerDelegate.h"
#import "AARDatePickerViewController.h"
#import "AARCycleDelegate.h"

#define OVULATION_DATE_SEGUE @"ovulationDatePickerSegue"

#define NOT_SET_STRING @"Not Set"

@interface AARDetailCycleViewController : UIViewController<AARDatePickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}

@property  id<AARCycleDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *saveSuccesLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (nonatomic) AARCycle* detailCycle;
@property (weak, nonatomic) IBOutlet UIButton *ovulationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@end
