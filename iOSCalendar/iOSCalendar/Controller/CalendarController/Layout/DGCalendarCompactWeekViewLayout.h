//
//  DGCalendarCompactWeekViewLayout.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekView.h"
#import "DGCalendarCompactWeekViewLayoutInvalidationContext.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const DGCalendarTopReusableViewKind = @"DGCalendarTopReusableViewKind";
static NSString* const DGCalendarMidReusableViewKind = @"DGCalendarMidReusableViewKind";

typedef NS_ENUM(NSInteger, DGSectionEquivalent) {
	DGSectionEquivalentWeek,
	DGSectionEquivalentMonth
};

@class DGCalendarCompactWeekViewLayout;

@protocol DGCalendarCompactWeekViewLayoutDelegate <NSObject>

@required
- (void)calendarCompactWeekViewLayout:(DGCalendarCompactWeekViewLayout*)layout shiftDateForWeeks:(NSInteger)weeks;

@end

@interface DGCalendarCompactWeekViewLayout : UICollectionViewLayout

@property (weak, nonatomic) id<DGCalendarCompactWeekViewLayoutDelegate> delegate;

@property (nonatomic, readonly) BOOL midViewExpanded;
@property (nonatomic, readonly) DGSectionEquivalent sectionEquivalent;
@property (readonly) NSInteger currentSection;

- (NSInteger)numberOfSections;
- (CGFloat)weekStartPositionForWeekWithIndexPath:(NSIndexPath*)indexPath;
- (void)toggleMidView;
- (void)forceInvalidateLayout;

@end

@interface UICollectionView (CalendarCompactWeekViewLayoutEasyAccess)

- (DGCalendarCompactWeekViewLayout*)compactWeekViewLayout;

@end

NS_ASSUME_NONNULL_END
