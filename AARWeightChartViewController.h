//
//  AARWeightChartViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARCycle.h"
#import "CorePlot-CocoaTouch.h"

#import "AARGraphDrawer.h"

@interface AARWeightChartViewController : UIViewController<CPTPlotSpaceDelegate,CPTRangePlotDataSource>
{
    AARGraphDrawer* graphDrawer;
    NSArray *cycleDays;
}

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphHostingView;
@property (nonatomic) AARCycle* weightChartCycle;

@property (weak, nonatomic) IBOutlet UILabel *cycleDatesLabel;
@end
