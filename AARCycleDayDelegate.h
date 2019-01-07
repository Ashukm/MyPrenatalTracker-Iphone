//
//  AARCycleDayDelegate.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/16/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AARCycleDayDelegate <NSObject>
@required
-(void)cycleDayChanged:(AARCycleDay*)newCycleDay;
@end
