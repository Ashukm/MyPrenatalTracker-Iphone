//
//  AARCalendarCollectionViewCell.h
//  PrenatalTracker
//
//  Created by Ashwini Anirudh Rao on 12/7/13.
//  Copyright (c) 2013 Ashwini Anirudh Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AARCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;

@end
