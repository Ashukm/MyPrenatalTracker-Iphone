//
//  AARCycleDetailMenuViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARCycleDelegate.h"

#define CYCLE_DETAIL_FROM_MENU_SEGUE @"cycleDetailFromMenuSegue"
#define CYCLE_CHART_FROM_MENU_SEGUE @"cycleChartFromMenuSegue"
#define CYCLE_CALENDAR_FROM_MENU_SEGUE @"cycleCalendarFromMenuSegue"

@interface AARCycleDetailMenuViewController : UITableViewController<UITableViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *cycleDateLabel;

@property  id<AARCycleDelegate> delegate;

@property (nonatomic) AARCycle* detailMenucycle;
@end
