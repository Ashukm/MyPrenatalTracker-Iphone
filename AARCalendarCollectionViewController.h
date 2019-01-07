//
//  AARCalendarCollectionViewController.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AARCalendarCollectionViewCell.h"
#import "AARCycle.h"
#import "AARCycleDayDelegate.h"

#define DAY_DETAIL_VIEW_SEGUE @"dayDetailViewSegue"

#define CALENDAR_COLLECTION_CELL_IDENTIFIER @"calendarCell"

#define MONDAY @"MON"
#define TUESDAY @"TUE"
#define WEDNESDAY @"WED"
#define THURSDAY @"THU"
#define FRIDAY @"FRI"
#define SATURDAY @"SAT"
#define SUNDAY @"SUN"
#define EMPTY_STRING @""
#define LOVE_IMAGE_NAME @"love.png"
#define PIN_IMAGE_NAME @"push-pin.png"

@interface AARCalendarCollectionViewController : UICollectionViewController<UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,AARCycleDayDelegate>
{
    NSArray *cycleDays;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic)AARCycle* calendarCycle;
@end
