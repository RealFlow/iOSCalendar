//
//  DGCalendarWeekMonthViewLayout.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const DGCalendarWeekMonthDayNameViewKind = @"DGCalendarWeekMonthDayNameViewKind";
static NSString* const DGCalendarWeekMonthDayCellKind = @"DGCalendarWeekMonthDayCellKind";

typedef NS_ENUM(NSInteger, DGCalendarMode) {
	kDGCalendarModeWeek,
	kDGCalendarModeMonth
};

@interface DGCalendarWeekMonthViewLayout : UICollectionViewLayout

@property DGCalendarMode mode;

@property NSInteger focusWeekIndex;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRows;

@end

@interface UICollectionView (CalendarWeekMonthViewLayoutEasyAccess)

- (DGCalendarWeekMonthViewLayout*)calendarWeekMonthViewLayout;

@end
NS_ASSUME_NONNULL_END
