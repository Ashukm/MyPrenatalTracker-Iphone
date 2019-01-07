//
//  AARGraphDrawer.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/16/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARGraphDrawer.h"
#define X_RANGE_MIN_CONSTANT 1
#define X_RANGE_LENGTH_CONSTANT 15

#define BBT_AANOTATION_STRING @"BBT = "
#define HCG_AANOTATION_STRING @"HCG = "
#define PRG_AANOTATION_STRING @"PRG = "
#define WEIGHT_AANOTATION_STRING @"WT. = "
#define INTERCOURSE_AANOTATION_STRING @"SEX = "
#define INT_YES @"Y"
#define INT_NO @"N"

@implementation AARGraphDrawer
{
   
    
    CPTColor *blueAppColor;
    CPTColor *pinkAppColor;
    CPTColor *yellowAppColor;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        blueAppColor = [CPTColor colorWithComponentRed:138.0/255.0 green:211.0/255.0  blue:344.0/255.0 alpha:1.0];
        
        pinkAppColor = [CPTColor colorWithComponentRed:249.0/255.0 green:195.0/255.0  blue:208.0/255.0 alpha:1.0];
        
        yellowAppColor = [CPTColor colorWithComponentRed:1.0 green:1.0  blue:204.0/255.0 alpha:1.0];
    }
    
    return self;
}

-(void)configureHost
{
    
    self.graphHostingView.allowPinchScaling = YES;
}

-(void)configureGraph
{
    //Create graph
    graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostingView.bounds];
    
    // [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
    
    self.graphHostingView.hostedGraph = graph;
    
    //Set graph title
    graph.title = self.graphTitle;
    
    //text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor darkGrayColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 18.0f);
    
    
    
    CPTGradient *grad = [CPTGradient gradientWithBeginningColor:yellowAppColor endingColor:[CPTColor whiteColor] beginningPosition:0 endingPosition:0.75];
    
    grad.angle = -90.0f;
    
    CPTFill *c = [CPTFill fillWithGradient:grad];
    
    
    graph.plotAreaFrame.fill = c;
    //graph.fill = [CPTFill fillWithColor:yellowAppColor];
    
    
    // Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    
   // graph.plotAreaFrame.masksToBorder = NO;
    
    //user interaction
    plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    
}

-(void)configurePlots
{
    //create plot
    plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
    scatterPlot = [[CPTScatterPlot alloc]init];
    
    scatterPlot.dataSource = self.graphDatasource;
    
    
    [graph addPlot:scatterPlot toPlotSpace:plotSpace];
    
    //create plot space
    [plotSpace scaleToFitPlots:@[scatterPlot]];
    
    [self setXYRanges];
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    
    //styles and symbols
    // CPTColor *bbtColor = [CPTColor redColor];
    CPTColor *bbtColor =  blueAppColor;
    CPTMutableLineStyle *bbtLineStyle = [scatterPlot.dataLineStyle mutableCopy];
    bbtLineStyle.lineWidth = 2.5;
    bbtLineStyle.lineColor = bbtColor;
    scatterPlot.dataLineStyle = bbtLineStyle;
    
    CPTMutableLineStyle *bbtSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    bbtSymbolLineStyle.lineColor = bbtColor;
    
    CPTPlotSymbol *bbtSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    bbtSymbol.fill = [CPTFill fillWithColor:bbtColor];
    bbtSymbol.lineStyle = bbtSymbolLineStyle;
    bbtSymbol.size = CGSizeMake(8.0f, 8.0f);
    
    scatterPlot.plotSymbol = bbtSymbol;
    
    /*
    //--------------------------------------
    CPTColor *acolo = [CPTColor colorWithComponentRed:0.3 green:0.1 blue:0.4 alpha:0.8];
    NSDecimalNumber *length = [NSDecimalNumber decimalNumberWithDecimal:yRange.midPoint];
    
    CPTGradient *grad = [CPTGradient gradientWithBeginningColor:blueAppColor endingColor:[CPTColor clearColor] beginningPosition:0 endingPosition:[length floatValue]/2.0];
    
    grad.angle = -90.0f;
    
    CPTFill *c = [CPTFill fillWithGradient:grad];
    scatterPlot.areaFill = c;
    scatterPlot.areaBaseValue=[[NSDecimalNumber zero]decimalValue];
    
     */
     
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [scatterPlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    scatterPlot.delegate = self.graphDelegate;
}


-(void)configureAxes
{
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    //axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.color = [CPTColor darkGrayColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    //axisLineStyle.lineColor = [CPTColor whiteColor];
    axisLineStyle.lineColor = [CPTColor darkGrayColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    //axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.color = [CPTColor darkGrayColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    //tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineColor = [CPTColor darkGrayColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = pinkAppColor;
    gridLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graphHostingView.hostedGraph.axisSet;
    
    
    // 3 - Configure x-axis
    CPTXYAxis *x = axisSet.xAxis;
    // x.title = @"Cycle Day";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    
    
    x.orthogonalCoordinateDecimal = plotSpace.yRange.location;
    NSInteger dayCount = 0;
    if(_graphCycle)
    {
        if(_graphCycle.cycleDays)
            dayCount =
            _graphCycle.cycleDays.count;
        
    }
    
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dayCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dayCount];
    NSInteger i = 0;
    for (int j =0 ;  j <=  dayCount; j++) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"CD%d",j]  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    x.visibleAxisRange = [CPTMutablePlotRange plotRangeWithLocation:(plotSpace.globalXRange.location) length:(plotSpace.globalXRange.length)];
    
    
    x.labelRotation = M_PI/2;
    x.labelAlignment = CPTAlignmentCenter;
    
    
    
    
    // 4 - Configure y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.title = self.graphTitle;
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -30.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    
    y.orthogonalCoordinateDecimal = plotSpace.xRange.location;
    
}


-(void)setXYRanges
{
    if(_cycleDays)
    {
        NSString *minString = [@"@min." stringByAppendingString:self.graphProperty];
         NSString *maxString = [@"@max." stringByAppendingString:self.graphProperty];
        
        NSInteger newMinYRange = [[_cycleDays valueForKeyPath:minString]integerValue];
        
        NSInteger newMaxYRange = [[_cycleDays valueForKeyPath:maxString]integerValue];
        
        NSInteger maxXRange = _cycleDays.count;
        CPTMutablePlotRange* xMaxRange;
        if(maxXRange < X_RANGE_LENGTH_CONSTANT)
        {
            xMaxRange = [CPTMutablePlotRange plotRangeWithLocation:CPTDecimalFromFloat(X_RANGE_MIN_CONSTANT) length:CPTDecimalFromFloat(maxXRange)];
            
            plotSpace.xRange =  xMaxRange;
            plotSpace.globalXRange = xMaxRange;
            
            
        }
        else
        {
            xMaxRange = [CPTMutablePlotRange plotRangeWithLocation:CPTDecimalFromFloat(X_RANGE_MIN_CONSTANT) length:CPTDecimalFromFloat(X_RANGE_LENGTH_CONSTANT)];
            
            plotSpace.xRange =  xMaxRange;
            
            
            CPTMutablePlotRange* xGlobalRange = [CPTMutablePlotRange plotRangeWithLocation:CPTDecimalFromFloat(X_RANGE_MIN_CONSTANT) length:CPTDecimalFromFloat(maxXRange)];
            
            plotSpace.globalXRange = xGlobalRange;
        }
        
        NSInteger newRangeLength = newMaxYRange-newMinYRange ;
        
        
        CPTMutablePlotRange* yMaxRange = [CPTMutablePlotRange plotRangeWithLocation:CPTDecimalFromFloat(newMinYRange) length:CPTDecimalFromFloat(newRangeLength )];
        
        plotSpace.yRange = yMaxRange;
        
        
        [yMaxRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
        plotSpace.globalYRange = yMaxRange;
        
        
        
    }
}

-(void)addGraphAnnotation:(NSNumber*)xPosition yPosition:(NSNumber*)yPosition cycleDay:(AARCycleDay*)cycleDay
{
     // NSLog(@"point selected %d",idx);
     
    if ( bbtAnnotation )
    {
         [graph.plotAreaFrame.plotArea removeAnnotation:bbtAnnotation];
         bbtAnnotation = nil;
    }
    if ( hcgAnnotation )
    {
        [graph.plotAreaFrame.plotArea removeAnnotation:hcgAnnotation];
        hcgAnnotation = nil;
    }
    if ( progesteroneAnnotation )
    {
        [graph.plotAreaFrame.plotArea removeAnnotation:progesteroneAnnotation];
        progesteroneAnnotation = nil;
    }
    if ( weightAnnotation )
    {
        [graph.plotAreaFrame.plotArea removeAnnotation:weightAnnotation];
        weightAnnotation = nil;
    }
    if ( intercourseAnnotation )
    {
        [graph.plotAreaFrame.plotArea removeAnnotation:intercourseAnnotation];
        intercourseAnnotation = nil;
    }
    
    if(cycleDay)
    {
     // Setup a style for the annotation
        CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
        hitAnnotationTextStyle.color    = [CPTColor darkGrayColor];
        hitAnnotationTextStyle.fontSize = 12.0;
       // hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
        hitAnnotationTextStyle.fontName = @"Helvetica";
        
    
        NSString *bbtString = [BBT_AANOTATION_STRING stringByAppendingString:[NSString stringWithFormat:@"%0.2f",cycleDay.bbt]];
    
        CPTTextLayer *bbtTextLayer = [[CPTTextLayer alloc]initWithText:bbtString style:hitAnnotationTextStyle];
        
        NSString *hcgString = [HCG_AANOTATION_STRING stringByAppendingString:[NSString stringWithFormat:@"%d",cycleDay.hcg]];
        
        CPTTextLayer *hcgTextLayer = [[CPTTextLayer alloc]initWithText:hcgString style:hitAnnotationTextStyle];
        
        NSString *prgString = [PRG_AANOTATION_STRING stringByAppendingString:[NSString stringWithFormat:@"%d",cycleDay.progestrone]];
        
        CPTTextLayer *prgTextLayer = [[CPTTextLayer alloc]initWithText:prgString style:hitAnnotationTextStyle];
        
        NSString *weightString = [WEIGHT_AANOTATION_STRING stringByAppendingString:[NSString stringWithFormat:@"%d",cycleDay.weight]];
        
        CPTTextLayer *weightTextLayer = [[CPTTextLayer alloc]initWithText:weightString style:hitAnnotationTextStyle];
        
        NSString * intString;
        
        if(cycleDay.intercouse)
            intString= [INTERCOURSE_AANOTATION_STRING stringByAppendingString:INT_YES];
        else
            intString= [INTERCOURSE_AANOTATION_STRING stringByAppendingString:INT_NO];
        
        CPTTextLayer *intTextLayer = [[CPTTextLayer alloc]initWithText:intString style:hitAnnotationTextStyle];
        
        bbtAnnotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
        hcgAnnotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
        weightAnnotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
        progesteroneAnnotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
        intercourseAnnotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
        
        intercourseAnnotation.displacement = CGPointMake(0.0f,-15.0f);
        progesteroneAnnotation.displacement = CGPointMake(0.0f,-30.0f);
        hcgAnnotation.displacement = CGPointMake(0.0f,-45.0f);
        weightAnnotation.displacement = CGPointMake(0.0f,-60.0f);


        bbtAnnotation.contentLayer = bbtTextLayer;
        intercourseAnnotation.contentLayer = intTextLayer;
        progesteroneAnnotation.contentLayer = prgTextLayer;
        hcgAnnotation.contentLayer = hcgTextLayer;
        weightAnnotation.contentLayer = weightTextLayer;
        
        [graph.plotAreaFrame.plotArea addAnnotation:bbtAnnotation];
        [graph.plotAreaFrame.plotArea addAnnotation:intercourseAnnotation];
        [graph.plotAreaFrame.plotArea addAnnotation:progesteroneAnnotation];
        [graph.plotAreaFrame.plotArea addAnnotation:hcgAnnotation];
        [graph.plotAreaFrame.plotArea addAnnotation:weightAnnotation];
        
    }
    /*
    CPTTextLayer *textLayer1 = [[CPTTextLayer alloc]initWithText:@"hello1"style:hitAnnotationTextStyle];
     
     
    graphAnnotation= [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
    
   // CPTAnnotation *s =[[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[[NSNumber numberWithInteger:[xPosition integerValue]] , [NSNumber numberWithFloat:[yPosition integerValue]+ 0.1]]];
    
    CPTAnnotation *s =[[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:@[xPosition, yPosition]];
    s.displacement = CGPointMake(0.0f,15.0f);
    
    graphAnnotation.contentLayer = textLayer;
    s.contentLayer = textLayer1;
    [graph.plotAreaFrame.plotArea addAnnotation:graphAnnotation];
    [graph.plotAreaFrame.plotArea addAnnotation:s];*/
}

@end
