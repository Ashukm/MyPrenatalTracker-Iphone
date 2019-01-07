//
//  AARDatabaseAccess.m
//  testTab
//
//  Created by Ashwini Anirudh Rao on 12/3/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARDatabaseAccess.h"


#define DATABASE_FILE_NAME @"prenatalTrackerDB.sqlite"

#define INSERT_CYCLE @"INSERT INTO cycles ""(start_date,end_date,length,ovulation_date,status)"" VALUES ""(?,?,?,?,?)"
#define INSERT_DAY @"INSERT INTO days ""(date,cycle_id,bbt,progestrone,weight,hcg,notes,ovulation_test,pregnancy_test,intercourse)"" VALUES ""(?,?,?,?,?,?,?,?,?,?)"

#define SELECT_CYCLE_ID @"SELECT id FROM cycles WHERE start_date=?"

#define SELECT_CYCLE_DAYS @"SELECT date,bbt,progestrone,weight,hcg,notes,ovulation_test,pregnancy_test,intercourse FROM days WHERE cycle_id=?"

#define COUNT_CYCLE_DAYS @"SELECT COUNT(*) FROM days WHERE cycle_id=?"

#define SELECT_ALL_CYCLES @"SELECT id,start_date,end_date,length,ovulation_date,status FROM cycles"

#define UPDATE_DAY_CYCLE @"UPDATE days SET cycle_id=? WHERE date=?"


#define UPDATE_DAY @"UPDATE days SET bbt=?,progestrone=?,weight=?,hcg=?,notes=?,ovulation_test=?,pregnancy_test=?,intercourse=? WHERE date=?"

#define UPDATE_CYCLE_STATUS_OVULATION @"UPDATE cycles SET status=?,ovulation_date=? WHERE id=?"

#define UPDATE_CYCLE @"UPDATE cycles SET status=?,ovulation_date=?,end_date=?,length=? WHERE id=?"

#define UPDATE_CYCLE_LENGTH @"UPDATE cycles SET length=? WHERE id=?"

#define DELETE_CYCLE_DAYS @"DELETE FROM days WHERE cycle_id=?"

#define DELETE_CYCLE @"DELETE FROM cycles WHERE id=?"

@implementation AARDatabaseAccess



static AARDatabaseAccess *instance = NULL;


/*Always returns only one instance of the database*/
+(AARDatabaseAccess *)getDatabaseInstance
{
    @synchronized(self){
        
        if(instance == NULL)
        {
            instance = [self new];
            instance.isOpen = FALSE;
            [instance registerForBackgroundtransitions];
        }
    }
    
    return instance;
}

/*Open DB*/
-(BOOL)openDatabase {
    
    if(self.isOpen) return YES;
    
    NSString *databasePath = [self getDatabasePath];
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        database = NULL;
        return NO;
    }
    self.isOpen = TRUE;
    return YES;
}

/*Close DB*/
-(void)closeDatabase{
    
    if(self.isOpen)
    {
        sqlite3_close(database);
        self.isOpen = NO;
    }
}

/*Returns DB file path*/
- (NSString *) getDatabasePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * appHome = NSHomeDirectory();
    NSString * documents = [appHome stringByAppendingPathComponent:@"Documents"];
    NSString * writableDB = [documents stringByAppendingPathComponent:DATABASE_FILE_NAME];
    
    if([fileManager fileExistsAtPath:writableDB])
    {
        return writableDB;
    }
    
    NSError *error;
    NSString *databasePath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:DATABASE_FILE_NAME];
    
    if([fileManager copyItemAtPath:databasePath toPath:writableDB error:&error])
    {
        return writableDB;
    }
   
    return NULL;
}


#pragma Database Table Actions

-(BOOL)insertNewCycle:(NSString *)startDate endDate:(NSString*)endDate cycleLength:(NSInteger)length ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status
{
    if(self.isOpen) //Check if database is open
    {
        sqlite3_stmt *insert;
        
        if(sqlite3_prepare_v2(database, [INSERT_CYCLE UTF8String], -1, &insert, nil)== SQLITE_OK)
        {
            sqlite3_bind_text(insert, 1, [startDate UTF8String], -1, NULL);
            sqlite3_bind_text(insert, 2, [endDate UTF8String], -1, NULL);
            sqlite3_bind_int(insert, 3, length);
            sqlite3_bind_text(insert, 4, [ovulationDate UTF8String], -1, NULL);
            sqlite3_bind_int(insert, 5, status);
            
            if(sqlite3_step(insert) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(insert);
            return YES;
        }
        return NO;
    }
    return NO;
}

-(BOOL)insertNewDay:(NSString *)currentDate cycle:(NSInteger)cycle_id bbt:(CGFloat)bbt progestrone:(NSInteger)progestrone weight:(NSInteger)weight hcg:(NSInteger)hcg notes:(NSString*)notes ovulationTest:(NSInteger)ovulationTest pregnancyTest:(NSInteger)pregnancyTest intercourse:(BOOL)intercourse
{
    //date,cycle_id,bbt,progestrone,weight,hcg,notes
    
    if(self.isOpen) //Check if database is open
    {
        sqlite3_stmt *insert;
        
        if(sqlite3_prepare_v2(database, [INSERT_DAY UTF8String], -1, &insert, nil)== SQLITE_OK)
        {
            sqlite3_bind_text(insert, 1, [currentDate UTF8String], -1, NULL);
            sqlite3_bind_int(insert, 2, cycle_id);
           // sqlite3_bind_int(insert, 3, bbt);
            sqlite3_bind_double(insert, 3,bbt);
            sqlite3_bind_int(insert, 4, progestrone);
            sqlite3_bind_int(insert, 5, weight);
            sqlite3_bind_int(insert, 6, hcg);
            sqlite3_bind_text(insert, 7, [notes UTF8String], -1, NULL);
            sqlite3_bind_int(insert, 8, ovulationTest);
            sqlite3_bind_int(insert, 9, pregnancyTest);
            sqlite3_bind_int(insert, 10, intercourse);
            
            if(sqlite3_step(insert) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(insert);
            return YES;
        }
        return NO;
    }
    return NO;
}


#pragma -mark Update records

-(BOOL)updateDay:(NSString *)date bbt:(CGFloat)bbt progestrone:(NSInteger)progestrone weight:(NSInteger)weight hcg:(NSInteger)hcg notes:(NSString*)notes ovulationTest:(NSInteger)ovulationTest pregnancyTest:(NSInteger)pregnancyTest intercourse:(BOOL)intercourse
{
    if(self.isOpen) //Check if database is open
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [UPDATE_DAY UTF8String], -1, &update, nil)== SQLITE_OK)
        {
            //sqlite3_bind_int(update, 1, bbt);
            sqlite3_bind_double(update, 1,bbt);
            sqlite3_bind_int(update, 2, progestrone);
            sqlite3_bind_int(update, 3, weight);
            sqlite3_bind_int(update, 4, hcg);
            sqlite3_bind_text(update,5, [notes UTF8String], -1, NULL);
            sqlite3_bind_int(update, 6, ovulationTest);
            sqlite3_bind_int(update, 7, pregnancyTest);
            sqlite3_bind_int(update, 8, intercourse);
            sqlite3_bind_text(update, 9, [date UTF8String], -1, NULL);
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
        }
        return NO;
    }
    return NO;

}

-(BOOL)updateCycleStatusOvulation:(NSInteger)cycleID ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [UPDATE_CYCLE_STATUS_OVULATION UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, status);
            sqlite3_bind_text(update,2, [ovulationDate UTF8String], -1, NULL);
            sqlite3_bind_int(update, 3, cycleID);
         
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;

        }
    }
    return NO;
}

-(BOOL)updateCycleLength:(NSInteger)cycleID length:(NSInteger)length
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [UPDATE_CYCLE_LENGTH UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, length);
            sqlite3_bind_int(update, 2, cycleID);
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
            
        }
    }
    return NO;
}



-(BOOL)updateCycle:(NSInteger)cycleID endDate:(NSString*)endDate cycleLength:(NSInteger)length ovulationDate:(NSString*)ovulationDate cycleStatus:(NSInteger)status
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [UPDATE_CYCLE UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, status);
            sqlite3_bind_text(update,2, [ovulationDate UTF8String], -1, NULL);
            sqlite3_bind_text(update,3, [endDate UTF8String], -1, NULL);
            sqlite3_bind_int(update, 4, cycleID);
            sqlite3_bind_int(update, 5, cycleID);
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
            
        }
    }
    return NO;
}


-(BOOL)updateCycleOfDate:(NSString*)date cycleID:(NSInteger)cycleID
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [UPDATE_DAY_CYCLE UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, cycleID);
            sqlite3_bind_text(update,2, [date UTF8String], -1, NULL);
   
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
            
        }
    }
    return NO;
}


#pragma -marl DB Delete 
-(BOOL)deleteCycleDays:(NSInteger)cycleID
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [DELETE_CYCLE_DAYS UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, cycleID);
            
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
            
        }
    }
    return NO;
}

-(BOOL)deleteCycle:(NSInteger)cycleID
{
    if(self.isOpen)
    {
        sqlite3_stmt *update;
        
        if(sqlite3_prepare_v2(database, [DELETE_CYCLE UTF8String], -1, &update, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(update, 1, cycleID);
            
            
            if(sqlite3_step(update) != SQLITE_DONE)
                return NO;
            
            sqlite3_finalize(update);
            return YES;
            
        }
    }
    return NO;
}


#pragma -mark DB Query

-(NSArray*)getAllCycles
{
    //id,start_date,end_date,length,ovulation_date,status
    NSMutableArray *cycles = [[NSMutableArray alloc]init];
    if(self.isOpen)
    {
        sqlite3_stmt *select;
        
        if(sqlite3_prepare_v2(database, [SELECT_ALL_CYCLES UTF8String], -1, &select, Nil)== SQLITE_OK)
        {
            while (sqlite3_step(select)==SQLITE_ROW) {
                
                NSInteger cycleID = 0;
                NSInteger length = 0;
                NSInteger status =0;
                
                cycleID = (NSInteger)sqlite3_column_int(select, 0);
                char *startDate = (char *)sqlite3_column_text(select, 1);
                char *endDate = (char *)sqlite3_column_text(select, 2);
                length = (NSInteger)sqlite3_column_int(select, 3);
                char *ovulationDate = (char *)sqlite3_column_text(select, 4);
                status = (NSInteger)sqlite3_column_int(select, 5);

                NSString* startDateString = @"";
                NSString *endDateString = @"";
                NSString* ovulationDateString = @"";
                
                if(startDate != NULL)
                    startDateString = [NSString stringWithUTF8String:startDate];
                
                if(endDate !=NULL)
                    endDateString =[NSString stringWithUTF8String:endDate];
                
                if(ovulationDate !=NULL)
                    ovulationDateString = [NSString stringWithUTF8String:ovulationDate];
                
                       
                NSDictionary *dbCycle = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:cycleID],startDateString,endDateString,ovulationDateString,[NSNumber numberWithInteger:length],[NSNumber numberWithInteger:status]] forKeys:@[CYCLE_ID_KEY,START_DATE_KEY,END_DATE_KEY,OVULATION_DATE_KEY,LENGTH_KEY,STATUS_KEY]];
                
                [cycles addObject:dbCycle];
                
            }
            
            if(cycles.count >0)
                return cycles;
            
        }
        return NULL;
    }
    return NULL;
    
}

-(NSInteger)getCycleID:(NSString*)cycleStartDate
{
    if(self.isOpen)
    {
        sqlite3_stmt *select;
        
        if(sqlite3_prepare_v2(database, [SELECT_CYCLE_ID UTF8String], -1, &select, Nil)== SQLITE_OK)
        {
            sqlite3_bind_text(select, 1, [cycleStartDate UTF8String], -1, NULL);
            
            if (sqlite3_step(select)==SQLITE_ROW)
            {
                NSInteger cycleID = (NSInteger)sqlite3_column_int(select, 0);
                return cycleID;
            }
        }
    }
    return -1;
}

-(NSArray *)getCycleDays:(NSInteger)cycleID
{
    //date,bbt,progestrone,weight,hcg,notes,ovulation_test,pregnancy_test,intercourse
    
    NSMutableArray *cycleDays = [[NSMutableArray alloc]init];
    if(self.isOpen)
    {
        sqlite3_stmt *select;
        
        if(sqlite3_prepare_v2(database, [SELECT_CYCLE_DAYS UTF8String], -1, &select, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(select, 1, cycleID);
            while (sqlite3_step(select)==SQLITE_ROW) {
                
                CGFloat bbt = 0;
                NSInteger progestrone = 0;
                NSInteger weight = 0;
                NSInteger hcg = 0;
                NSInteger ovulation = 0;
                NSInteger pregnancy = 0;
                BOOL intercourse = NO;
                
                char *date = (char *)sqlite3_column_text(select, 0);
                bbt = (CGFloat)sqlite3_column_int(select, 1);
                progestrone = (NSInteger)sqlite3_column_int(select, 2);
                weight = (NSInteger)sqlite3_column_int(select, 3);
                hcg = (NSInteger)sqlite3_column_int(select, 4);
                char *notes = (char *)sqlite3_column_text(select, 5);
                ovulation = (NSInteger)sqlite3_column_int(select, 6);
                pregnancy = (NSInteger)sqlite3_column_int(select, 7);
                intercourse = (BOOL)sqlite3_column_int(select, 8);
                
                NSString *dateString = @"";
                NSString *notesString = @"";
                
                if(date != NULL)
                    dateString = [NSString stringWithUTF8String:date];
                
                if(notes!=NULL)
                    notesString = [NSString stringWithUTF8String:notes];
                
                NSDictionary *day = [NSDictionary dictionaryWithObjectsAndKeys:dateString,DATE_KEY,[NSNumber numberWithInteger:cycleID],CYCLE_ID_KEY,[NSNumber numberWithFloat:bbt],BBT_KEY,[NSNumber numberWithInteger:progestrone],PROGESTRONE_KEY,[NSNumber numberWithInteger:weight],WEIGHT_KEY,[NSNumber numberWithInteger:hcg],HCG_KEY,notesString,NOTES_KEY,[NSNumber numberWithInteger:ovulation],OVULATION_TEST_KEY,[NSNumber numberWithInteger:pregnancy],PREGNANCY_TEST_KEY,[NSNumber numberWithBool:intercourse],INTERCOURSE_KEY, nil];
                
                [cycleDays addObject:day];
            }
            
            if(cycleDays.count > 0)
            {
                return cycleDays;
            }
        }
        return NULL;
    }
    return NULL;
}

-(NSInteger)countCycleDays:(NSInteger)cycleID
{
    if(self.isOpen)
    {
        sqlite3_stmt *select;
        
        if(sqlite3_prepare_v2(database, [COUNT_CYCLE_DAYS UTF8String], -1, &select, Nil)== SQLITE_OK)
        {
            sqlite3_bind_int(select, 1, cycleID);
            
            if (sqlite3_step(select)==SQLITE_ROW)
            {
                NSInteger count = (NSInteger)sqlite3_column_int(select, 0);
                return count;
            }
        }
    }
    return -1;
}


-(void)dealloc
{
    [self unregisterForBackgroundtransitions];
}

#pragma Lifecycle Events

-(void)registerForBackgroundtransitions{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:application];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:application];
}
-(void)unregisterForBackgroundtransitions{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)applicationWillResignActive:(NSNotification *)notification{
    
    [self closeDatabase];
}

-(void)applicationWillEnterForeground:(NSNotification *)notification{
    
    [self openDatabase];
}

@end
