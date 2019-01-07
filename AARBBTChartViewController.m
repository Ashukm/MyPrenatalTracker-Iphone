//
//  AARBBTChartViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARBBTChartViewController.h"

#define GRAPH_TITLE @"BBT CHART"
#define GRAPH_PROPERTY @"bbt"

@interface AARBBTChartViewController ()

@end

@implementation AARBBTChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setBbtChartCycle:(AARCycle *)bbtChartCycle
{
    _bbtChartCycle = bbtChartCycle;
    
    if(_bbtChartCycle)
    {
        NSArray *tempArray  = _bbtChartCycle.cycleDays;
        if(tempArray)
        {
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
            
            cycleDays = [tempArray sortedArrayUsingDescriptors:@[sortByDate]];
            
        }
        else
            cycleDays = NULL;
    }
    else
        cycleDays = NULL;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self labelCycledates];
    
    if(_bbtChartCycle)
    {
        graphDrawer = [[AARGraphDrawer alloc]init];
        graphDrawer.graphCycle = _bbtChartCycle;
        graphDrawer.graphDatasource =self;
        graphDrawer.graphDelegate = self;
        graphDrawer.graphHostingView = self.graphHostingView;
        graphDrawer.graphProperty = GRAPH_PROPERTY;
        graphDrawer.graphTitle = GRAPH_TITLE;
        graphDrawer.cycleDays = cycleDays;
        [graphDrawer configureHost];
        [graphDrawer configureGraph];
        [graphDrawer configurePlots];
        [graphDrawer configureAxes];
    }
}


-(void)labelCycledates
{
    if(_bbtChartCycle)
    {
        NSString *startDateString = [self cycleDateString:_bbtChartCycle.startDate];
        NSString *endEndString = [self cycleDateString:_bbtChartCycle.endDate];
        NSString *labelString = NULL;
        if(endEndString)
        {
            NSString *tempString = [startDateString stringByAppendingString:@"-"];
            labelString = [tempString stringByAppendingString:endEndString];
            
        }
        else
        {
            labelString = startDateString;
        }
        
        self.cycleDatesLabel.text = labelString;
    }
}


#pragma -mark CPTGraph Datasource delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if(cycleDays)
    {
        return cycleDays.count;
    }
    
    return 0;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
  if(cycleDays)
    {
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [NSNumber numberWithUnsignedInteger:idx + 1];
            break;
        case CPTScatterPlotFieldY:
            return  [NSNumber numberWithInteger:((AARCycleDay*)cycleDays[idx]).bbt];
            break;
        default:
            break;
    }
    }
    return 0;
}


#pragma -mark plot space delegate methods
-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx
{
    
    
    AARCycleDay* cycleDay = (AARCycleDay*)cycleDays[idx];
    
    NSNumber *xPosition = [NSNumber numberWithUnsignedInteger:idx+1];
    NSNumber *yposition = [NSNumber numberWithInteger:cycleDay.bbt];
    
    [graphDrawer addGraphAnnotation:xPosition yPosition:yposition cycleDay:cycleDay];
}

#pragma -mark Helper Functions

-(NSString*)cycleDateString:(NSDate *)cycleDate
{
    if(cycleDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        
        return [dateFormatter stringFromDate:cycleDate];
    }
    return NULL;
}


@end
