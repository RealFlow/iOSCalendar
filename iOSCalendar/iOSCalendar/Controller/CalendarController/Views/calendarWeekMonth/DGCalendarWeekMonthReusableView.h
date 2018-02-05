//
//  DGCalendarWeekMonthReusableView.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarEvent.h"
#import "DGCalendarCompactWeekReusableView.h"
#import "DGCalendarWeekMonthDayCell.h"
#import "DGCalendarWeekMonthDayNameView.h"
#import "DGCalendarWeekMonthViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

static NSString* const kDGCalendarWeekMonthReusableViewUpdateLayoutMode = @"kDGCalendarWeekMonthReusableViewUpdateLayoutMode";

@class DGCalendarWeekMonthReusableView;
@class DGCalendarWeekMonthReusableViewDateRange;
@class DGCalendarWeekMonthReusableViewDataModel;

@protocol DGCalendarWeekMonthReusableViewDelegate <NSObject>
@required
- (void)calendarWeekMonthReusableView:(DGCalendarWeekMonthReusableView*)view didSelectDate:(NSDate*)date;

@end

@interface DGCalendarWeekMonthReusableView : DGCalendarCompactWeekReusableView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic, nullable) id<DGCalendarWeekMonthReusableViewDelegate> delegate;

@property UIColor* monthViewBackgroundColor UI_APPEARANCE_SELECTOR;

+ (void)updateAllCalendarWeekMonthReusableViewsWithNewMode:(DGCalendarMode)mode;
- (void)updateWithDataModel:(DGCalendarWeekMonthReusableViewDataModel*)dataModel;
- (DGCalendarWeekMonthReusableViewDateRange*)dateRangeForDate:(NSDate*)date;

@end

@interface DGCalendarWeekMonthReusableViewDateRange : NSObject

@property (nonatomic) NSDate* startDate;
@property (nonatomic) NSDate* endDate;

@end

@interface DGCalendarWeekMonthReusableViewDataModel : NSObject

@property (nonatomic) NSDate* date;
@property (nonatomic) DGCalendarMode mode;
@property (nonatomic) NSArray<DGCalendarEvent*>* events;
@property (nonatomic) NSArray* passiveDays;

@end

NS_ASSUME_NONNULL_END
