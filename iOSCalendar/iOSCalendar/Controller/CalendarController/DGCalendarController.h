//
//  DGCalendarController.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekReusableView.h"
#import "DGCalendarCompactWeekViewLayout.h"
#import "DGCalendarFilterBarReusableView.h"
#import "DGCalendarWeekMonthReusableView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DGCalendarUIMode) {
	kDGCalendarUIModeStandBy,
	kDGCalendarUIModeProcessing,
	kDGCalendarUIModeDEFAULT = kDGCalendarUIModeStandBy
};

@class DGCalendarController;

@protocol DGCalendarControllerDelegate <NSObject>

- (void)calendarController:(DGCalendarController*)ctrl requiresMode:(DGCalendarMode)mode;
- (void)calendarController:(DGCalendarController*)ctrl didChangeSelectedDate:(NSDate*)selectedDate;
- (void)calendarController:(DGCalendarController*)ctrl didChangeFocusedDate:(NSDate*)focusedDate;
- (void)calendarController:(DGCalendarController*)ctrl didChangeSize:(CGSize)size;
- (NSArray*)calendarController:(DGCalendarController*)ctrl requiresEventsFrom:(NSDate*)fromDate to:(NSDate*)toDate;
- (NSArray*)calendarController:(DGCalendarController*)ctrl requiresPassiveDaysFrom:(NSDate*)fromDate to:(NSDate*)toDate;

@end

@interface DGCalendarController : UIViewController <
									   UICollectionViewDataSource,
									   UICollectionViewDelegate,
									   DGCalendarCompactWeekViewLayoutDelegate,
									   DGCalendarFilterBarReusableViewDelegate,
									   DGCalendarWeekMonthReusableViewDelegate>

@property (weak, nonatomic) id<DGCalendarControllerDelegate> delegate;

@property (nonatomic, readonly) NSDate* selectedDate;

+ (CGFloat)heightForMode:(DGCalendarMode)mode;

- (void)updateWithSelectedDate:(NSDate*)selectedDate;
- (void)updateWithMode:(DGCalendarMode)mode;
- (void)updateWithUIMode:(DGCalendarUIMode)uiMode;
- (void)reloadData;
- (void)smartReloadData;
- (void)switchMode;

@end

NS_ASSUME_NONNULL_END
