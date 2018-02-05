//
//  DGCalendarWeekMonthDayCell.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarWeekMonthReusableView.h"
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DGCalendarWeekMonthDayCellStyleOptions) {
	DGCalendarWeekMonthDayCellStyleNormal = (1 << 0),
	DGCalendarWeekMonthDayCellStyleOtherMonth = (1 << 1),
	DGCalendarWeekMonthDayCellStyleCurrentWeek = (1 << 2),
	DGCalendarWeekMonthDayCellStyleSelected = (1 << 3),
	DGCalendarWeekMonthDayCellStyleToday = (1 << 4)
};

NS_ASSUME_NONNULL_BEGIN

@class DGCalendarWeekMonthDayCellEventHelper;
@interface DGCalendarWeekMonthDayCell : UICollectionViewCell
@property (nonatomic) NSDate* date;

@property UIColor* dayTextColorToday UI_APPEARANCE_SELECTOR;
@property UIColor* dayTextColorThisMonth UI_APPEARANCE_SELECTOR;
@property UIColor* dayTextColorOtherMonth UI_APPEARANCE_SELECTOR;
@property UIColor* dayTextColorSelected UI_APPEARANCE_SELECTOR;
@property UIColor* dayViewBackgroundColor UI_APPEARANCE_SELECTOR;
@property UIColor* dayViewBackgroundColorToday UI_APPEARANCE_SELECTOR;
@property UIColor* dayViewBackgroundColorSelected UI_APPEARANCE_SELECTOR;

+ (NSString*)reuseIdentifier;

- (void)updateWithDate:(NSDate*)date;
- (void)updateWithMonthDayEvents:(NSArray<DGCalendarWeekMonthDayCellEventHelper*>*)events showRealColor:(BOOL)showRealColor;
- (void)updateWithOptions:(DGCalendarWeekMonthDayCellStyleOptions)options;

@end

@interface DGCalendarWeekMonthDayCellEventHelper : NSObject

@property (nonatomic) UIColor* color;

@end

NS_ASSUME_NONNULL_END
