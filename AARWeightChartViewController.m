//
//  AARWeightChartViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/10/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARWeightChartViewController.h"

#define GRAPH_TITLE @"WEIGHT CHART"
#define GRAPH_PROPERTY @"weight"

@interface AARWeightChartViewController ()

@end

@implementation AARWeightChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setWeightChartCycle:(AARCycle *)weightChartCycle
{
    _weightChartCycle = weightChartCycle;

    
    if(_weightChartCycle)
    {
        NSArray *tempArray  = _weightChartCycle.cycleDays;
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
    
    
    if(_weightChartCycle)
    {
        
        graphDrawer = [[AARGraphDrawer alloc]init];
        graphDrawer.graphCycle = _weightChartCycle;
        graphDrawer.graphDatasource = self;
        graphDrawer.graphDelegate = self;
        graphDrawer.graphHostingView = self.graphHostingView;
        graphDrawer.graphProperty = GRAPH_PROPERTY;
        graphDrawer.graphTitle = GRAPH_TITLE;
        graphDrawer.cycleDays = cycleDays;
        
        
        [self labelCycledates];
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
    if(_weightChartCycle)
    {
        NSString *startDateString = [self cycleDateString:_weightChartCycle.startDate];
        NSString *endEndString = [self cycleDateString:_weightChartCycle.endDate];
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
                return  [NSNumber numberWithInteger:((AARCycleDay*)cycleDays[idx]).weight];
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
    /*// NSLog(@"point selected %d",idx);
    
    if ( graphAnnotation ) {
        [graph.plotAreaFrame.plotArea removeAnnotation:graphAnnotation];
        
        graphAnnotation = nil;
    }
    
    
    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontSize = 16.0;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc]initWithText:@"hello"style:hitAnnotationTextStyle];
    
    
    
    graphAnnotation= [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[[NSNumber numberWithUnsignedInteger:idx+1], [NSNumber numberWithInteger:((AARCycleDay*)cycleDays[idx]).weight]]];
    
    graphAnnotation.contentLayer = textLayer;
    [graph.plotAreaFrame.plotArea addAnnotation:graphAnnotation];*/
    
    AARCycleDay* cycleDay = (AARCycleDay*)cycleDays[idx];
    
    NSNumber *xPosition = [NSNumber numberWithUnsignedInteger:idx+1];
    NSNumber *yposition = [NSNumber numberWithInteger:cycleDay.weight];
    
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
