//
//  DGCalendarWeekMonthViewLayout.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarWeekMonthViewLayout.h"

#define NUMBER_OF_WEEKS 6
#define NUMBER_OF_DAYS 7

#define WEEK_DAY_WIDTH (self.collectionView.bounds.size.width / NUMBER_OF_DAYS)
#define WEEK_DAY_HEIGHT (20)
#define WEEK_DAY_START_POSITION(WEEK_DAY_INDEX) (WEEK_DAY_WIDTH * (WEEK_DAY_INDEX))

#define MONTH_DAY_WIDTH WEEK_DAY_WIDTH
#define MONTH_DAY_HEIGHT (35) // INFO: originally 30, but it conflicts with day selection circle size on week mode
#define MONTH_DAY_HORIZONTAL_START_POSITION(MONTH_DAY_INDEX_PATH) (MONTH_DAY_WIDTH * (MONTH_DAY_INDEX_PATH.item))
#define MONTH_DAY_VERTICAL_START_POSITION(MONTH_DAY_INDEX_PATH) (WEEK_DAY_HEIGHT + MONTH_DAY_HEIGHT * (MONTH_DAY_INDEX_PATH.section) - (self.mode == kDGCalendarModeWeek ? (MONTH_DAY_HEIGHT * FOCUS_WEEK_INDEX) : 0))

#define FOCUS_WEEK_INDEX (self.focusWeekIndex)

@interface DGCalendarWeekMonthViewLayout ()

@property NSDictionary<NSString*, NSDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>*>* layoutInfo;

@end

@implementation DGCalendarWeekMonthViewLayout

#pragma mark - Layout

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
	[super prepareForAnimatedBoundsChange:oldBounds];
}

- (void)prepareLayout
{
	[super prepareLayout];
	NSMutableDictionary<NSString*, NSDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>*>* layoutInfo = @{}.mutableCopy;
	NSMutableDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>* dayNameViewLayoutInfo = @{}.mutableCopy;
	NSMutableDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>* dayCellLayoutInfo = @{}.mutableCopy;

	for (NSInteger monthWeekIndex = 0; monthWeekIndex < self.collectionView.numberOfSections; monthWeekIndex++) {
		for (NSInteger weekDayIndex = 0; weekDayIndex < [self.collectionView numberOfItemsInSection:monthWeekIndex]; weekDayIndex++) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForItem:weekDayIndex inSection:monthWeekIndex];
			if (dayNameViewLayoutInfo.count < NUMBER_OF_DAYS) {
				UICollectionViewLayoutAttributes* dayNameViewAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:DGCalendarWeekMonthDayNameViewKind withIndexPath:indexPath];
				[dayNameViewAttributes setFrame:[self frameForDayNameViewForWeekDayWithIndex:weekDayIndex]];
				[dayNameViewAttributes setZIndex:10];
				dayNameViewLayoutInfo[indexPath] = dayNameViewAttributes;
			}

			UICollectionViewLayoutAttributes* dayCellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
			[dayCellAttributes setFrame:[self frameForDayCellWithIndexPath:indexPath]];
			[dayCellAttributes setAlpha:self.mode == kDGCalendarModeWeek ? (monthWeekIndex == FOCUS_WEEK_INDEX ? 1 : 0) : 1];
			[dayCellAttributes setTransform:self.mode == kDGCalendarModeWeek ? (monthWeekIndex == FOCUS_WEEK_INDEX ? CGAffineTransformMakeScale(1.1, 1.1) : CGAffineTransformMakeScale(0.1, 0.1)) : CGAffineTransformIdentity];
			[dayCellAttributes setZIndex:self.mode == kDGCalendarModeWeek ? (monthWeekIndex == FOCUS_WEEK_INDEX ? 9 : monthWeekIndex) : 9];
			dayCellLayoutInfo[indexPath] = dayCellAttributes;
		}
	}

	layoutInfo[DGCalendarWeekMonthDayNameViewKind] = dayNameViewLayoutInfo;
	layoutInfo[DGCalendarWeekMonthDayCellKind] = dayCellLayoutInfo;

	[self setLayoutInfo:layoutInfo];
}

- (NSArray<UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray<UICollectionViewLayoutAttributes*>* layoutAttributes = @[].mutableCopy;

	for (NSString* kind in self.layoutInfo.allKeys) {
		for (UICollectionViewLayoutAttributes* attributes in self.layoutInfo[kind].allValues) {
			//            if (CGRectIntersectsRect(rect, self.layoutInfo[kind][indexPath].frame)) {
			//                [layoutAttributes addObject:self.layoutInfo[kind][indexPath]];
			//            }

			[layoutAttributes addObject:attributes];
		}
	}

	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath
{
	return self.layoutInfo[elementKind][indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath
{
	return self.layoutInfo[elementKind][indexPath];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
	return self.layoutInfo[DGCalendarWeekMonthDayCellKind][indexPath];
}

#pragma mark - Frames

- (CGRect)frameForDayNameViewForWeekDayWithIndex:(NSInteger)index
{

	CGFloat weakStart = WEEK_DAY_START_POSITION(0);

	CGFloat weakEnd = WEEK_DAY_START_POSITION(6);

	CGFloat space = weakEnd - weakStart + MONTH_DAY_WIDTH;
	CGFloat finalSpace = space - 20;
	CGFloat offset = space - finalSpace;
	CGFloat segmentWidth = finalSpace / 7;

	return CGRectMake((offset * 0.5) + segmentWidth * index, 0, segmentWidth, WEEK_DAY_HEIGHT);
}

- (CGRect)frameForDayCellWithIndexPath:(NSIndexPath*)indexPath
{

	CGFloat weakStart = MONTH_DAY_HORIZONTAL_START_POSITION([NSIndexPath indexPathForItem:0 inSection:indexPath.section]);

	CGFloat weakEnd = MONTH_DAY_HORIZONTAL_START_POSITION([NSIndexPath indexPathForItem:0 + 6 inSection:indexPath.section]);

	CGFloat space = weakEnd - weakStart + MONTH_DAY_WIDTH;
	CGFloat finalSpace = space - 20;
	CGFloat offset = space - finalSpace;
	CGFloat segmentWidth = finalSpace / 7;

	return CGRectMake((offset * 0.5) + segmentWidth * indexPath.item,
		MONTH_DAY_VERTICAL_START_POSITION(indexPath),
		segmentWidth,
		MONTH_DAY_HEIGHT);
}

#pragma mark - Params

- (NSInteger)numberOfSections
{
	return NUMBER_OF_WEEKS;
}

- (NSInteger)numberOfRows
{
	return NUMBER_OF_DAYS;
}

- (CGSize)collectionViewContentSize
{
	return self.collectionView.bounds.size;
}

@end

@implementation UICollectionView (CalendarWeekMonthViewLayoutEasyAccess)

- (DGCalendarWeekMonthViewLayout*)calendarWeekMonthViewLayout
{
	return (DGCalendarWeekMonthViewLayout*)self.collectionViewLayout;
}

@end
