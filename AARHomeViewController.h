//
//  AARHomeViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/6/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"

#import "AARNewCurrentCycleViewController.h"
#import "AARCycleDayDelegate.h"

#define CHART_MENU_SEGUE @"chartMenuSegue"
#define CALENDAR_SEGUE @"calendarSegue"
#define MORE_DAY_DETAILS_SEGUE @"moreDayDetailsSegue"
#define NEW_CYCLE_SEGUE @"newCycleSegue"
#define DETAIL_CYCLE_VIEW_SEGUE @"detailCycleViewSegue"
#define MAIN_MENU_SEGUE @"mainMenuSegue"

#define EMPTY_STRING @""

@interface AARHomeViewController : UIViewController<AARCycleDelegate,AARCycleDayDelegate,UIGestureRecognizerDelegate>
{
    AARCycle* homeCycle;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCycleStartDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *todayBBTTextField;
@property (weak, nonatomic) IBOutlet UISwitch *todayOvulationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *ovulationSwitchResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailCycleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *calendarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *chartButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

-(void)updateCurrentCycle:(AARCycle *)currentCycle;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UILabel *saveMessageLabel;
- (IBAction)todayOvulationSwitchValueChanged:(UISwitch *)sender;
- (IBAction)todayDetailsSave:(UIButton *)sender;

@end
