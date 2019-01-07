//
//  AARCycleDelegate.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/12/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AARCycleDelegate <NSObject>
@required
-(void)updateCurrentCycle:(AARCycle*)newCurrentcycle;
@end
