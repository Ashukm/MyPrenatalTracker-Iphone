//
//  AARCycleDay.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARCycleDay.h"

@implementation AARCycleDay

-(id)initWithDate :(NSDate*) newDate
{
    self = [super init];
    
    if(self)
    {
        self.date = newDate;
    }
    
    return self;
}

-(BOOL)addCycleDay
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    if(_date)
    {
        NSString *dateDbString = [self getDBStringFromDate:_date];
        
        return [database insertNewDay:dateDbString cycle:_cycleId bbt:_bbt progestrone:_progestrone weight:_weight hcg:_hcg notes:_notes ovulationTest:_ovulationTest pregnancyTest:_prenancyTest intercourse:_intercouse];
    }
    
    return NO;
}

-(BOOL)updateCycleDay
{
    database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    if(_date)
    {
        NSString *dateDbString = [self getDBStringFromDate:_date];
        
        return [database updateDay:dateDbString bbt:_bbt progestrone:_progestrone weight:_weight hcg:_hcg notes:_notes ovulationTest:_ovulationTest pregnancyTest:_prenancyTest intercourse:_intercouse];
    }
    
    return NO;

}

#pragma -mark Helper Functions
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

+(BOOL)updateDayCycle :(NSInteger)cycleID date:(NSDate *)date
{
    AARDatabaseAccess *database = [AARDatabaseAccess getDatabaseInstance];
    [database openDatabase];
    
    if(date)
    {
        AARCycleDay *temp = [[AARCycleDay alloc]init];
        
        NSString *dateDbString = [temp getDBStringFromDate:date];
        return [database updateCycleOfDate:dateDbString cycleID:cycleID];

    }
    return NO;
}
@end
