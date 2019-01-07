//
//  AARGraphDrawer.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/16/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AARCycle.h"
#import "CorePlot-CocoaTouch.h"

/*
 ----------------------------------------------------------------------
 MODEL CLASS
 Handles logic behind creating data for plotting graphs , setting up axes and plot spaces. The data to be displayed is manipulated to be plotted on graph.
 ----------------------------------------------------------------------
 */
@interface AARGraphDrawer : NSObject
{
    CPTXYGraph *graph;
    CPTPlotSpaceAnnotation *bbtAnnotation;
    CPTPlotSpaceAnnotation *hcgAnnotation;
    CPTPlotSpaceAnnotation *progesteroneAnnotation;
    CPTPlotSpaceAnnotation *weightAnnotation;
    CPTPlotSpaceAnnotation *intercourseAnnotation;
    
    CPTScatterPlot* scatterPlot;
    CPTXYPlotSpace *plotSpace;
    
  
}

@property (strong, nonatomic) CPTGraphHostingView *graphHostingView;
@property NSString * graphTitle;
@property NSArray *cycleDays;
@property NSString* graphProperty;
@property AARCycle *graphCycle;
@property  id<CPTPlotSpaceDelegate> graphDelegate;
@property id<CPTRangePlotDataSource> graphDatasource;

-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)addGraphAnnotation:(NSNumber*)xPosition yPosition:(NSNumber*)yPosition cycleDay:(AARCycleDay*)cycleDay;

@end
