//
//  AARCycle.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARCycle.h"
#define DELETE_CONFIRM_MESSAGE @"Do you really want to delete cycle?"
#define CANCEL_BUTTON_TITLE @"Cancel"
#define CONFIRM_BUTON_TITLE @"Delete"
#define EMPTY_STRING @""

@implementation AARCycle
{
    UIAlertView *deleteAlert;
}

-(id)init
{
    self=[super init];
    if(self)
    {
        _cycleTimeStatus = NOT_SET;
        days = NULL;
    }
    
    return self;
}
-(id)initWithStartDate :(NSDate*)startDate
{
    if(self = [super init])
    {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        NSDate *today = [calendar dateFromComponents:components];
        
        _startDate = today;
        _cycleTimeStatus = NOT_SET;
        days = NULL;
        return self;
    }
    return self;
}

-(NSArray*)cycleDays
{

    if(days == NULL)
        days = [self cycleDaysForCycle];
    
    if(_cycleTimeStatus == INVALID)
        return NULL;
    
    return days;
    
}

#pragma -mark Database Operations

-(BOOL)addPreviousCycle
{
    if([self addCycle])
    {
        
        NSMutableArray * newCycleDays = [[NSMutableArray alloc]init];
        NSDate *currentDate  = [[NSDate alloc]initWithTimeInterval:0 sinceDate:_startDate];
        
        for (int i =0; i<_length; i++) {
            
            AARCycleDay* newDay = [self addCycleDay:currentDate];
            
            [newCycleDays addObject:newDay];
            
            NSDateComponents *components = [[NSDateComponents alloc]init];
            components.day = 1;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            currentDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
            
        }        
        
        if(newCycleDays.count == _length)
        {
            days = newCycleDays;
            return YES;
        }
        
    }
    return NO;
}

-(BOOL)addCycle
{
    NSString* startDayString = [self getDBStringFromDate:self.startDate];
    
    if(![self checkValidEndDate])
        return NO;
    
    if(![self checkValidOvulationDate])
        _ovulationDate = NULL;
    
    
    if([self checkValidCycle])
    {
        _length = [self getCycleDaysCount];
        
        database = [AARDatabaseAccess getDatabaseInstance];
        [database openDatabase];
        
        if([database insertNewCycle:startDayString endDate:[self getDBStringFromDate:self.endDate] cycleLength:self.length ovulationDate:[self getDBStringFromDate:self.ovulationDate] cycleStatus:self.cycleStatus])
        {
            NSInteger cycleID = [database getCycleID:startDayString];
            if(cycleID < 0)
            {
                return NO;
            }
            
            _ID = cycleID;
            [self isCurrentCycle];
            return YES;
        }
    }
    return NO;
}

-(BOOL)updateCycle
{
    
    if(![self checkValidEndDate])
        return NO;
    
    if(![self checkValidOvulationDate])
        _ovulationDate = NULL;
    
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    NSString* ovulationDayString = [self getDBStringFromDate:self.ovulationDate];
    NSString* endDayString = [self getDBStringFromDate:self.endDate];
    
    return [database updateCycle:_ID endDate:endDayString cycleLength:_length ovulationDate:ovulationDayString cycleStatus:_cycleStatus];
}

-(BOOL)updateOvulationStatus
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    if(![self checkValidOvulationDate])
        _ovulationDate = NULL;

    
    NSString* ovulationDayString = [self getDBStringFromDate:self.ovulationDate];
    
    return [database updateCycleStatusOvulation:_ID ovulationDate:ovulationDayString cycleStatus:_cycleStatus];

}

#pragma -mark Helper Functions

-(BOOL)checkValidEndDate
{
    if(_startDate)
    {
        if(_endDate)
        {
            if ([_endDate compare:_startDate] == NSOrderedDescending)
                return YES;
            else
                return NO;
        }
        return YES;
    }
    return NO;
}


-(BOOL)checkValidOvulationDate
{
    if(_startDate)
    {
        if(_endDate)
        {
            if(_ovulationDate)
            {
                if ([_ovulationDate compare:_startDate] == NSOrderedDescending && [_ovulationDate compare:_endDate] == NSOrderedAscending)
                    return YES;
                else
                    return NO;
            }
            return YES;
        }
        return YES;
    }
    return NO;
}

-(BOOL)checkValidCycle
{
    if(self.startDate)
    {
        NSArray *cycles = [AARCycle getAllCycles];
        if(self.endDate)
        {
            if([self checkIfDateBetweenCycle:self.startDate allCycles:cycles] || [self checkIfDateBetweenCycle:self.endDate allCycles:cycles])
            {
                return NO; // not a valid cycle if date lies in between
            }
        }
        else
        {
            if([self checkIfDateBetweenCycle:self.startDate allCycles:cycles])
                return NO;
        }
    }
    return YES;
}


-(BOOL)checkIfDateBetweenCycle:(NSDate*)date allCycles:(NSArray*)allCycles
{
    for (AARCycle* cycle in allCycles) {
        
        if(cycle.startDate && cycle.endDate)
        {
            if (([date compare:cycle.startDate] == NSOrderedDescending) &&
                ([date compare:cycle.endDate] == NSOrderedAscending)) {
                
               //date lies between start and end days of existing cycle
                return YES;
            }
        }
        else
            return NO;
    }
    
    return NO;
}

-(NSInteger)isCurrentCycle
{
    if(!_startDate)
    {
        _cycleTimeStatus = INVALID;
        return INVALID_CYCLE;
    }
    if(_endDate)
    {
        NSComparisonResult compareResult = [_endDate compare:[NSDate date]];
        if(compareResult == NSOrderedAscending)
        {
            //old cycle
            _cycleTimeStatus = OLD;
            return OLD_CYCLE;
        }
        else
        {
            //end date > than today current cycle
            _cycleTimeStatus = CURRENT;
            return CURRENT_CYCLE;
        }
    }
    else
    {
        //current cycle
        _cycleTimeStatus = CURRENT;
        return CURRENT_CYCLE;
    }
}

-(NSInteger)getCycleDaysCount
{
    //return [database countCycleDays:_ID];
    [self isCurrentCycle];
    if( _cycleTimeStatus == INVALID)
        return INVALID_CYCLE;
    
    NSInteger countFromDays;
    if(_cycleTimeStatus == OLD)
    {
        countFromDays = [self countDaysInBetween:_startDate endDay:_endDate];
        
        if(countFromDays == INVALID_CYCLE)
            return INVALID_CYCLE;
    }
    else
    {
        //current cycle
        countFromDays = [self countDaysInBetween:_startDate endDay:[NSDate date]];
        
        if(countFromDays == INVALID_CYCLE)
            return INVALID_CYCLE;
    }
    
    return countFromDays;
}

-(NSInteger)getCycleDaysCountFromDB
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    NSInteger daysCount = [database countCycleDays:_ID];
    return daysCount;
}

-(NSArray*)cycleDaysForCycle
{
    NSArray* daysInDB = NULL;
    
    //get cycle length from start date to today
    
    NSInteger actualDaysCount = [self getCycleDaysCount];
    NSInteger dbDaysCount = [self getCycleDaysCountFromDB];
    
    NSInteger daysDifference = actualDaysCount - dbDaysCount;
    
    if(daysDifference < 0)
    {
        //db has more records than cycle start - end. Invalid
        _cycleTimeStatus = INVALID;
        return NULL;
    }
    
    [self isCurrentCycle];

    if(_cycleTimeStatus == INVALID)
            return NULL;
    
    
    daysInDB = [self getCycleDaysFromDB];
    
    if(_cycleTimeStatus == CURRENT)
    {
        if(daysDifference > 0)
        {
            //cycle days missing in current cycle. Add days
            NSArray * newCycleDays = [self addDaysInCycle:daysInDB actualDayCount:actualDaysCount];
            
            return newCycleDays;
        }
       
    }
    else if (_cycleTimeStatus == OLD)
    {
        if(daysDifference > 0)
        {
            //cycle days missing for an old cycle invalid cycle
            _cycleTimeStatus = INVALID;
            return NULL;
        }
    }
   
    return daysInDB;
}

-(NSArray*)addDaysInCycle:(NSArray*)arrayFromDB actualDayCount:(NSInteger)actualDayCount
{
    if(arrayFromDB)
    {
        if(arrayFromDB.count == actualDayCount)
            return arrayFromDB; // No need to add any days
    }
    
    NSMutableArray* newCycleDays;
    BOOL daysExist = NO;
    
    if(arrayFromDB)
    {
        newCycleDays = [[NSMutableArray alloc]initWithArray:arrayFromDB];
        daysExist = YES;
    }
    else
    {
        newCycleDays = [[NSMutableArray alloc]init];
    }
    
    NSDate *currentDate  = [[NSDate alloc]initWithTimeInterval:0 sinceDate:_startDate];
    
    
    for (int i =0; i<actualDayCount; i++)
    {
        if(daysExist)
        {
            //check if days already exists in array
       
           // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date compare:%@ == NSOrderedSame",currentDate];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date == %@)" argumentArray:@[currentDate]];

            
            NSArray *compareResult = [newCycleDays filteredArrayUsingPredicate:predicate];
            
            if(compareResult)
            {
                if(compareResult.count == 0)
                {
                    //no day exists
                    //add day to array
                    AARCycleDay *newDay = [self addCycleDay:currentDate];
                    [newCycleDays addObject:newDay];
                }
            }
            else
            {
                //no day exists
                //add day to array
                AARCycleDay *newDay = [self addCycleDay:currentDate];
                [newCycleDays addObject:newDay];
            }
        }
        else
        {
            //add day to array
            AARCycleDay *newDay = [self addCycleDay:currentDate];
            if(newDay)
            {
                [newCycleDays addObject:newDay];
            }
        }
        //increment date
        
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.day = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        currentDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
        
    }
    
    if(newCycleDays.count == actualDayCount)
    {
        _length = actualDayCount;
        [database openDatabase];
        [database updateCycleLength:_ID length:_length];
        return newCycleDays;
    }
    
    _cycleTimeStatus = INVALID;
    return NULL;
}

-(AARCycleDay*)addCycleDay :(NSDate *)cycleDay
{
    if(cycleDay)
    {
        AARCycleDay *newDay = [[AARCycleDay alloc]initWithDate:cycleDay];
        newDay.cycleId = _ID;
        
        if([newDay addCycleDay])
            return newDay;
    }
    
    return NULL;
}

-(NSInteger)countDaysInBetween:(NSDate*)startDay endDay:(NSDate*)endDay
{
    
    if(startDay && endDay)
    {
        NSDateComponents *components = [[NSDateComponents alloc]init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        components = [calendar components:NSDayCalendarUnit fromDate:startDay toDate:endDay options:0];
        return components.day+1; //inclusive difference
    }
    
    return -1;
}

-(NSArray *)getCycleDaysFromDB
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    NSArray *daysFromDB = [database getCycleDays:_ID];
    
    //date,bbt,progestrone,weight,hcg,notes,ovulation_test,pregnancy_test,intercourse
    
    if(daysFromDB)
    {
        NSMutableArray *cycleDaysFromDB = [[NSMutableArray alloc]init];
        for (NSDictionary *dayFromDB in daysFromDB)
        {
            NSString *date = (NSString*)[dayFromDB objectForKey:DATE_KEY];
            
            if(date)
            {
                AARCycleDay* day = [[AARCycleDay alloc]init];
                day.date = [self getDateFromDBString:date];
                day.cycleId = [(NSNumber*)[dayFromDB objectForKey:CYCLE_ID_KEY] integerValue];
                day.bbt = [(NSNumber*)[dayFromDB objectForKey:BBT_KEY] integerValue];
                day.progestrone = [(NSNumber*)[dayFromDB objectForKey:PROGESTRONE_KEY]integerValue];
                day.weight = [(NSNumber*)[dayFromDB objectForKey:WEIGHT_KEY]integerValue];
                day.hcg = [(NSNumber*)[dayFromDB objectForKey:HCG_KEY]integerValue];
                day.notes = (NSString*)[dayFromDB objectForKey:NOTES_KEY];
                day.ovulationTest = [(NSNumber*)[dayFromDB objectForKey:OVULATION_TEST_KEY]integerValue];
                day.prenancyTest = [(NSNumber*)[dayFromDB objectForKey:PREGNANCY_TEST_KEY]integerValue];
                day.intercouse = [(NSNumber*)[dayFromDB objectForKey:INTERCOURSE_KEY]boolValue];
                
                [cycleDaysFromDB addObject:day];
            }
        }
        
        if(cycleDaysFromDB.count > 0)
            return cycleDaysFromDB;
    }
    return NULL;

}

-(NSString*)getDBStringFromDate : (NSDate*)date
{
    if(date)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMddyyyy"];
        
        return [dateFormatter stringFromDate:date];
    }
    
    return NULL;
}

-(NSDate*)getDateFromDBString : (NSString*)dateString
{
    if(dateString && !([dateString isEqualToString:@""]))
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMddyyyy"];
        
        return [dateFormatter dateFromString:dateString];
    }
    
    return NULL;
}

-(BOOL)deleteCycle
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    if([database deleteCycleDays:_ID])
    {
        if([database deleteCycle:_ID])
            return YES;
        else
            return NO;
    }
    return NO;

}


#pragma -mark Validations
-(BOOL)validateStartDate:(id*)ioValue error:(NSError*)outError
{
    NSDate* newStartDate = (NSDate*)*ioValue;
    
    NSDate *currentDate = [NSDate date];
    
    if([newStartDate compare:currentDate] == NSOrderedDescending)
    {
      //start date greater than current date error
      NSDictionary *userInforDict = @{NSLocalizedDescriptionKey : START_DATE_ERROR_STRING};
      outError = [[NSError alloc]initWithDomain:START_DATE_ERROR_DOMAIN code:START_DATE_ERROR_CODE userInfo:userInforDict];
      return NO;
    }
    return YES;
    
}

-(void)setCycleID:(NSInteger)cycleID
{
    _ID = cycleID;
}

#pragma -mark Class methods
+(BOOL)deleteCycle:(AARCycle*)cycle
{
    return [cycle deleteCycle];   
}

+(NSArray*)getAllCycles
{
    AARDatabaseAccess *database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    NSArray *cyclesFromDB = [database getAllCycles];
    
    if(cyclesFromDB)
    {
        NSMutableArray *cycles = [[NSMutableArray alloc]init];
        
        for (NSDictionary *cycleDictionary  in cyclesFromDB)
        {            
            if(cycleDictionary)
            {
                AARCycle *newCycle = [[AARCycle alloc]init];
                
                [newCycle setCycleID:[(NSNumber*)[cycleDictionary objectForKey:CYCLE_ID_KEY] integerValue]];
               
                newCycle.startDate = [newCycle getDateFromDBString:[cycleDictionary objectForKey:START_DATE_KEY]];
                
                newCycle.endDate = [newCycle getDateFromDBString:[cycleDictionary objectForKey:END_DATE_KEY]];
                
                newCycle.ovulationDate = [newCycle getDateFromDBString:[cycleDictionary objectForKey:OVULATION_DATE_KEY]];
                
                newCycle.length = [(NSNumber*)[cycleDictionary objectForKey:LENGTH_KEY]integerValue];
                newCycle.cycleStatus = [(NSNumber*)[cycleDictionary objectForKey:STATUS_KEY] integerValue];
                
                [cycles addObject:newCycle];
            }
        }
        
        if(cycles.count >0)
        {
            NSInteger currentCycleID= [AARCycle findCurrentCycle:cycles];
            [AARCycle setCurrentCycleFlag:cycles currentCycleID:currentCycleID];
            return cycles;
        }
    }
    return NULL;
}

-(void)setCurentCycleStatuFlag:(enum cycleTime)flag
{
    _cycleTimeStatus = flag;
}

+(AARCycle*)getCurrentCycle
{
    
    NSArray *cycles = [AARCycle getAllCycles];
    
    if(cycles)
    {
        NSInteger currentCycleID= [AARCycle findCurrentCycle:cycles];
        AARCycle *currentCycle = [AARCycle setCurrentCycleFlag:cycles currentCycleID:currentCycleID];
        return currentCycle;
    }
    
    return NULL;
}

+(NSInteger)findCurrentCycle :(NSArray *)allCycles
{
    if(allCycles)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        NSDate *today = [calendar dateFromComponents:components];
      
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(endDate == %@) OR (endDate == NULL) OR (endDate > %@)" argumentArray:@[today,today]];
        
        NSArray *compareResult = [allCycles filteredArrayUsingPredicate:predicate];
        
        if(compareResult)
        {
            if(compareResult.count == 1)
            {
                NSInteger currentCycleID =((AARCycle*)compareResult[0]).ID;
                [AARCycle setCurrentCycleFlag:allCycles currentCycleID:currentCycleID];
                return currentCycleID;
            }
            else
                return -1;
        }
        else
            return -1;
    }
    
    return -1;
}

+(AARCycle*)setCurrentCycleFlag :(NSArray*)allCycles currentCycleID:(NSInteger)currentCycleID
{
    AARCycle * currentCycle = NULL;
    for (AARCycle* cycle in allCycles)
    {
        if(cycle.ID == currentCycleID)
        {
            [cycle setCurentCycleStatuFlag:CURRENT];
            currentCycle = cycle;
        }
        else
        {
            [cycle setCurentCycleStatuFlag:OLD];
        }
    }
    
    return currentCycle;
}

@end
