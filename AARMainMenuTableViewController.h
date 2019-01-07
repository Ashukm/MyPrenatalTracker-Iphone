//
//  AARMainMenuTableViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/9/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARCycleDelegate.h"

#define  CALENDAR_MENU_SEGUE @"calendarMenuSegue"
#define CHART_MENU_SEGUE @"chartMenuSegue"
#define CYCLE_DETAIL_MENU_SEGUE @"cycleDetailMenuSegue"
#define CYCLES_SEGUE @"cyclesSegue"

@interface AARMainMenuTableViewController : UITableViewController<UITableViewDelegate,AARCycleDelegate>

@property (nonatomic) AARCycle* mainMenuCycle;
@end

