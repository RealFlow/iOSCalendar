//
//  DGCalendarCompactWeekReusableView.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@interface DGCalendarCompactWeekReusableView : UICollectionReusableView

@property (strong, nonatomic) NSIndexPath* indexPath;

+ (NSString*)reuseIdentifier;

@end
NS_ASSUME_NONNULL_END
