//
//  AARChartMenuViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "AARBBTChartViewController.h"
#import "AARProgestroneChartViewController.h"
#import "AARHCGChartViewController.h"
#import "AARWeightChartViewController.h"

#define BBT_CHART_SEGUE @"bbtChartSegue"
#define PROGESTRONE_CHART_SEGUE @"progesteroneChartSegue"
#define WEIGHT_CHART_SEGUE @"weightChartSegue"
#define HCG_CHART_SEGUE @"hcgChartSegue"


@interface AARChartMenuViewController : UITableViewController
{
    
}
@property AARCycle* chartMenuCycle;
@end
