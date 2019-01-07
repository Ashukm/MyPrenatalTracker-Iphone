//
//  AARCycle.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AARDatabaseAccess.h"
#import "AARCycleDay.h"

#define START_DATE_ERROR_STRING @"Start date cannot be later than today's date"
#define START_DATE_ERROR_DOMAIN @"Start date error domain"
#define START_DATE_ERROR_CODE 1


#define INVALID_CYCLE -1
#define OLD_CYCLE 1
#define CURRENT_CYCLE 2

/*
 ------------------------------------------------------------------------------
 MODEL CLASS
 
 The class saves the cycle information. It keeps track of current cycle , old cycles , cycle data and cycle days. It helps in creating cycles and hanldes conflict of days between two cycles . Provides interface to add , modify and delete cycle.
 ------------------------------------------------------------------------------
 */


enum cycleTime {
    INVALID = -1,
    NOT_SET = 0,
    OLD = 1,
    CURRENT = 2
    };

@interface AARCycle : NSObject
{
    AARDatabaseAccess* database;
    NSArray *days;
   
}

@property (readonly,nonatomic)NSArray* cycleDays;
@property (readonly,nonatomic) NSInteger ID;
@property (nonatomic)NSDate *startDate;
@property (nonatomic)NSDate *endDate;
@property (nonatomic)NSDate *ovulationDate;
@property (nonatomic)NSInteger length;
@property (nonatomic)NSInteger cycleStatus;
@property (nonatomic, readonly)enum cycleTime cycleTimeStatus;



-(id)initWithStartDate :(NSDate*)startDate;
-(BOOL)addCycle;
-(BOOL)addPreviousCycle;
-(BOOL)updateCycle;
-(BOOL)updateOvulationStatus;

+(NSArray*)getAllCycles;
+(AARCycle*)getCurrentCycle;
+(BOOL)deleteCycle:(AARCycle*)cycle;

@end

