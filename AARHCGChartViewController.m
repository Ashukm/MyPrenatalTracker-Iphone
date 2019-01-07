//
//  AARHCGChartViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARHCGChartViewController.h"

#define GRAPH_TITLE @"HCG CHART"
#define GRAPH_PROPERTY @"hcg"

@interface AARHCGChartViewController ()

@end

@implementation AARHCGChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setHcgChartCycle:(AARCycle *)hcgChartCycle
{
    _hcgChartCycle = hcgChartCycle;

    
    if(_hcgChartCycle)
    {
        NSArray *tempArray  = _hcgChartCycle.cycleDays;
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
    
    if(_hcgChartCycle)
    {
        graphDrawer = [[AARGraphDrawer alloc]init];
        graphDrawer.graphCycle = _hcgChartCycle;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)labelCycledates
{
    if(_hcgChartCycle)
    {
        NSString *startDateString = [self cycleDateString:_hcgChartCycle.startDate];
        NSString *endEndString = [self cycleDateString:_hcgChartCycle.endDate];
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
                return  [NSNumber numberWithInteger:((AARCycleDay*)cycleDays[idx]).hcg];
                break;
            default:
                break;
        }
    }
    return 0;
}


#pragma -mark plot space delegate methods

-(CPTPlotRange*)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    /*if(coordinate == CPTCoordinateY){
        CPTPlotRange* yRange ;
        UIDevice * device = [UIDevice currentDevice];
        UIDeviceOrientation orientation = device.orientation;
        
        //no change in Y co-ordinate
        yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minYRange) length:CPTDecimalFromFloat(yRangeLength)];
        // NSLog(@"change to portarit");
        
        return yRange;
    }*/
    
    return newRange;
}



-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx
{
   
    
    AARCycleDay* cycleDay = (AARCycleDay*)cycleDays[idx];
    
    NSNumber *xPosition = [NSNumber numberWithUnsignedInteger:idx+1];
    NSNumber *yposition = [NSNumber numberWithInteger:cycleDay.hcg];
    
    [graphDrawer addGraphAnnotation:xPosition yPosition:yposition cycleDay:cycleDay];
}


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
