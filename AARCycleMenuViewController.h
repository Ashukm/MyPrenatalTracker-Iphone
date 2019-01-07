//
//  AARCycleMenuViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/9/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARCycleMenuTableViewCell.h"
#import "AARCycleDetailMenuViewController.h"
#import "AARCycleDelegate.h"

#define CYCLE_DETAIL_MENU_SEGUE @"cycleDetailMenuSegue"

@interface AARCycleMenuViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *allCycles;
}
@property (strong, nonatomic) IBOutlet UITableView *cycleTableView;
@property AARCycle* menuCurrentCycle;
@property  id<AARCycleDelegate> delegate;
@end
