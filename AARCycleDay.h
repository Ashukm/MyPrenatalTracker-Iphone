//
//  AARCycleDay.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AARDatabaseAccess.h"

/*
 -------------------------------------------------------------------------------
 MODEL CLASS
 The cycle day stores data for bbt , hcg , progesterone , weight of the day.
 It also provides interface for storing , retreiving , updating and deleteing cycle days of a cycle.
 -------------------------------------------------------------------------------
 */

@interface AARCycleDay : NSObject
{
     AARDatabaseAccess* database;
}

@property NSDate *date;
@property NSInteger cycleId;
@property CGFloat bbt;
@property NSInteger progestrone;
@property NSInteger weight;
@property NSInteger hcg;
@property NSString* notes;
@property NSInteger ovulationTest;
@property NSInteger prenancyTest;
@property BOOL intercouse;

-(BOOL)addCycleDay;
-(id)initWithDate :(NSDate*) newDate;
-(BOOL)updateCycleDay;

+(BOOL)updateDayCycle :(NSInteger)cycleID date:(NSDate *)date;
@end
