//
//  AARDatabaseAccess.h
//  testTab
//
//  Created by Ashwini Anirudh Rao on 12/3/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

#define DATE_KEY @"date"
#define CYCLE_ID_KEY @"cycle_id"
#define BBT_KEY @"bbt"
#define PROGESTRONE_KEY @"progestrone"
#define WEIGHT_KEY @"weight"
#define HCG_KEY @"hcg"
#define NOTES_KEY @"notes"
#define OVULATION_TEST_KEY @"ovulation"
#define PREGNANCY_TEST_KEY @"pregnancy"
#define INTERCOURSE_KEY @"intercourse"



#define START_DATE_KEY @"start_date"
#define END_DATE_KEY @"end_date"
#define LENGTH_KEY @"length"
#define OVULATION_DATE_KEY @"ovulation_date"
#define STATUS_KEY @"status"


/*
 ------------------------------------------------------------------
 
 MODEL CLASS
 
 The class provides functionality to access the database on the device. It stores , retreives and updates data in the database.
 
 Database Structure 
 
 
 ===============            ===========================
     CYCLE      |           |       DAYS               |
 ===============            ===========================
 id             |           | date                     |
 start date     |           | cycle_id (FK  cycle ->id)|
 end data       |           | bbt                      |
 ovulation date |           | hcg                      |
 cycle length   |           | progesterone             |
 status         |           | weight                   |
 ===============            | intercourse              |
                            | pregnancy test           |
                            | ovulation test           |
                            ----------------------------
 
 
 ------------------------------------------------------------------
 */

@interface AARDatabaseAccess : NSObject
{
    sqlite3 *database; //Database which stores all the users and photos data
}

@property BOOL isOpen;

+(AARDatabaseAccess *)getDatabaseInstance;

-(BOOL)openDatabase;
-(void)closeDatabase;

-(BOOL)insertNewCycle:(NSString *)startDate endDate:(NSString*)endDate cycleLength:(NSInteger)length ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status;

-(BOOL)insertNewDay:(NSString *)currentDate cycle:(NSInteger)cycle_id bbt:(CGFloat)bbt progestrone:(NSInteger)progestrone weight:(NSInteger)weight hcg:(NSInteger)hcg notes:(NSString*)notes ovulationTest:(NSInteger)ovulationTest pregnancyTest:(NSInteger)pregnancyTest intercourse:(BOOL)intercourse;

- (NSString *) getDatabasePath;
-(NSInteger)getCycleID:(NSString*)cycleStartDate;

-(NSArray *)getCycleDays:(NSInteger)cycleID;

-(NSInteger)countCycleDays:(NSInteger)cycleID;

-(NSArray*)getAllCycles;


-(BOOL)updateDay:(NSString *)date bbt:(CGFloat)bbt progestrone:(NSInteger)progestrone weight:(NSInteger)weight hcg:(NSInteger)hcg notes:(NSString*)notes ovulationTest:(NSInteger)ovulationTest pregnancyTest:(NSInteger)pregnancyTest intercourse:(BOOL)intercourse;

-(BOOL)updateCycleStatusOvulation:(NSInteger)cycleID ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status;


-(BOOL)updateCycle:(NSInteger)cycleID endDate:(NSString*)endDate cycleLength:(NSInteger)length ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status;

-(BOOL)updateCycleOfDate:(NSString*)date cycleID:(NSInteger)cycleID;

-(BOOL)updateCycleLength:(NSInteger)cycleID length:(NSInteger)length;

-(BOOL)deleteCycleDays:(NSInteger)cycleID;
-(BOOL)deleteCycle:(NSInteger)cycleID;

@end
