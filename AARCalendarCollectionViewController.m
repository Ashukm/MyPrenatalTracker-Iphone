//
//  AARCalendarCollectionViewController.m
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import "AARCalendarCollectionViewController.h"
#import "AARDetailDayViewController.h"

@interface AARCalendarCollectionViewController ()
{
    NSInteger selectedIndex;
    NSInteger dayStartindex;
    
    UIColor *blueAppColor;
    UIColor *pinkAppColor;
    UIColor *yellowAppColor;
}
@end

@implementation AARCalendarCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setCalendarCycle:(AARCycle *)calendarCycle
{
    _calendarCycle = calendarCycle;
    if(_calendarCycle)
    {
        cycleDays = _calendarCycle.cycleDays;
        
        NSArray *tempArray  = _calendarCycle.cycleDays;
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
    
    
    selectedIndex = -1;
    dayStartindex = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    blueAppColor = [UIColor colorWithRed:138.0/255.0 green:211.0/255.0 blue:344.0/255.0 alpha:1.0];
    
    pinkAppColor = [UIColor colorWithRed:249.0/255.0 green:195.0/255.0 blue:208.0/255.0 alpha:1.0];
    
    yellowAppColor = [UIColor colorWithRed:1.0 green:1.0 blue:204.0/255.0 alpha:1.0];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:DAY_DETAIL_VIEW_SEGUE])
    {
        NSInteger rowIndex = selectedIndex - dayStartindex;
        [[segue destinationViewController]setCycleDay:rowIndex+1];
        [[segue destinationViewController]setDetailDay:cycleDays[rowIndex]];
        ((AARDetailDayViewController*)segue.destinationViewController).delegate = self;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if([identifier isEqualToString:DAY_DETAIL_VIEW_SEGUE])
    {
        return NO;
    }
    
    return YES;
}

#pragma -mark Collection view data source methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = 7 + [self getEmptyCellCount];
    
    dayStartindex = itemCount;
    
    if(self.calendarCycle)
    {
        
        
        if(cycleDays)
        {
           
            return (cycleDays.count + itemCount);
        }
        
        return itemCount;
    }
    
    return itemCount;

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    }

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AARCalendarCollectionViewCell *cell = (AARCalendarCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_COLLECTION_CELL_IDENTIFIER forIndexPath:indexPath];
    
    if(cell == NULL)
    {
        cell=[[AARCalendarCollectionViewCell alloc]init];
    }
    
    
   
    
    [self prepareCellForDisplay:cell row:indexPath.row];
    
    return cell;
}

#pragma -mark Collection view delegate methods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    if(selectedIndex >= dayStartindex )
        [self performSegueWithIdentifier:DAY_DETAIL_VIEW_SEGUE sender:self];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize;
    if(self.interfaceOrientation == UIDeviceOrientationPortrait)
    {
        itemSize = CGSizeMake(40, 58);
        
    }
    else
    {
        itemSize = CGSizeMake(75, 58);
    }
    
    return itemSize;
}

#pragma -mark cycle day delegate
-(void)cycleDayChanged:(AARCycleDay *)newCycleDay
{
    [self.collectionView reloadData];
}

#pragma -mark Helper Functions

-(void)prepareCellForDisplay:(AARCalendarCollectionViewCell*)cell row:(NSInteger)row
{
    NSInteger emptyCellCount  = [self getEmptyCellCount];
   
    if( row < 7)
    {
        //weekday header cell
        [self setWeekDayTitleCell:cell row:row];
        return;
    }
    else if( row  < (7 + emptyCellCount))
    {
        //empty cell
        [self setEmptyCell:cell];
        return;
    }
    NSInteger dayArrayIndex = row-emptyCellCount-7;
    [self setCycleDayCell:cell row:dayArrayIndex];
    
}
-(void)setWeekDayTitleCell:(AARCalendarCollectionViewCell*)cell row:(NSInteger)row
{
   
    cell.backgroundColor = blueAppColor;
    
    cell.tintColor = [UIColor whiteColor];
    cell.cellTempLabel.text= EMPTY_STRING;
    cell.loveImageView.image = NULL;
    cell.cellDateLabel.text=EMPTY_STRING;
    cell.cellHeaderLabel.textColor = [UIColor whiteColor];
    
    
     NSString *pinImagePath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:PIN_IMAGE_NAME];
    
    cell.pinImageView.image = [UIImage imageWithContentsOfFile:pinImagePath];
    
   
    
    switch (row) {
        case 0:
            cell.cellHeaderLabel.text = MONDAY;
            break;
        case 1:
            cell.cellHeaderLabel.text = TUESDAY;
            break;
        case 2:
            cell.cellHeaderLabel.text = WEDNESDAY;
            break;
        case 3:
            cell.cellHeaderLabel.text = THURSDAY;
            break;
        case 4:
            cell.cellHeaderLabel.text = FRIDAY;
            break;
        case 5:
            cell.cellHeaderLabel.text = SATURDAY;
            break;
        case 6:
            cell.cellHeaderLabel.text = SUNDAY;
            break;
        default:
            break;
    }
    
}

-(NSInteger)getEmptyCellCount
{
    if (self.calendarCycle) {
        
        NSDateComponents *components = [[NSDateComponents alloc]init];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        components = [calendar components:NSCalendarUnitWeekday fromDate:self.calendarCycle.startDate];
        
        switch (components.weekday) {
            case 1: //Sunday
                return 6;
                break;
            case 2://Monday
                return 0;
                break;
            case 3://tue
                return 1;
            case 4://wed
                return 2;
            case 5://thu
                return 3;
            case 6://fri
                return 4;
            case 7://sat
                return 5;
            default:
                break;
        }
    }
    return 0;
}

-(void)setEmptyCell:(AARCalendarCollectionViewCell*)cell
{
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cellTempLabel.text= EMPTY_STRING;
    cell.loveImageView.image = NULL;
    cell.cellDateLabel.text=EMPTY_STRING;
    cell.pinImageView.image = NULL;
    cell.cellHeaderLabel.text=EMPTY_STRING;
}

-(void)setCycleDayCell:(AARCalendarCollectionViewCell*)cell row:(NSInteger)row
{
    //cycle day format

    
    if(cycleDays[row])
    {
        AARCycleDay *day = (AARCycleDay*)cycleDays[row];
        
        cell.tintColor = [UIColor darkGrayColor];
        cell.cellTempLabel.text= [NSString stringWithFormat:@"%0.1f",day.bbt];
        
        //cell.backgroundColor = yellowAppColor;
       // cell.cellTempLabel.textColor = [UIColor darkGrayColor];
       
        if(day.intercouse)
        {
            NSString *loveImagePath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:LOVE_IMAGE_NAME];
            
            cell.loveImageView.image = [UIImage imageWithContentsOfFile:loveImagePath];
        }
        else
        {
            cell.loveImageView.image = NULL;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MMMdd"];
        
        cell.cellDateLabel.text= [dateFormatter stringFromDate:day.date];
        
        
        
        cell.cellHeaderLabel.textColor = [UIColor blackColor];
        //cell.cellHeaderLabel.backgroundColor = [UIColor lightGrayColor];
        cell.cellTempLabel.textColor = [UIColor darkGrayColor];
        cell.cellHeaderLabel.textColor = [UIColor darkGrayColor];
        cell.cellDateLabel.textColor = [UIColor darkGrayColor];
        cell.cellHeaderLabel.text= [NSString stringWithFormat:@"CD%d",row+1];
        NSString *pinImagePath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:PIN_IMAGE_NAME];
        
        cell.pinImageView.image = [UIImage imageWithContentsOfFile:pinImagePath];
       // cell.backgroundColor = [UIColor colorWithRed:178 green:171 blue:255 alpha:0.5];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
         NSDateComponents *components  = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        NSDate *today = [calendar dateFromComponents:components];
        
        if([day.date compare:today] == NSOrderedSame)
        {
            cell.backgroundColor = pinkAppColor;
        }
        else
        {
            cell.backgroundColor = yellowAppColor;
        }
    }
}
@end
