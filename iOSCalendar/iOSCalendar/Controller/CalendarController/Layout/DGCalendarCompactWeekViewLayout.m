//
//  DGCalendarCompactWeekViewLayout.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekViewLayout.h"

#define NUMBER_OF_WEEKS 8

#define WEEK_WIDTH self.collectionView.bounds.size.width

#define WEEKS_GROUP_WIDTH (WEEK_WIDTH * NUMBER_OF_WEEKS)

#define CONTENT_WIDTH (NUMBER_OF_WEEKS * WEEK_WIDTH)
#define CONTENT_HEIGHT (self.collectionView.bounds.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom)
#define CONTENT_SIZE CGSizeMake(CONTENT_WIDTH, CONTENT_HEIGHT)

#define WEEKS_GROUP_START_POSITION ((CONTENT_WIDTH * .5) - (WEEKS_GROUP_WIDTH * .5))
#define WEEK_START_POSITION(WEEK_INDEX) (WEEKS_GROUP_START_POSITION + (WEEK_WIDTH * (WEEK_INDEX)))
#define WEEKS_GROUP_END_POSITION (WEEK_START_POSITION(NUMBER_OF_WEEKS))

#define WEEK_VERTICAL_START_POSITION 0

#define TOP_VIEW_HEIGHT 40

#define MID_VIEW_VERTICAL_POSITION (WEEK_VERTICAL_START_POSITION + TOP_VIEW_HEIGHT)
#define MID_VIEW_HEIGHT_COLLAPSED 50
#define MID_VIEW_HEIGHT_EXPANDED (MID_VIEW_HEIGHT_COLLAPSED * 5) // IMPORTANT: 250 same height as DGCalendarWeekMonthReusableView collectionView
#define MID_VIEW_HEIGHT (self.midViewExpanded ? MID_VIEW_HEIGHT_EXPANDED : MID_VIEW_HEIGHT_COLLAPSED)

// not used in this implementation
#define BOT_VIEW_VERTICAL_POSITION (MID_VIEW_VERTICAL_POSITION + MID_VIEW_HEIGHT)
#define BOT_VIEW_HEIGHT (CONTENT_HEIGHT - TOP_VIEW_HEIGHT - MID_VIEW_HEIGHT)

NS_OPTIONS(NSInteger, DGCalendarCompactWeekViewContentOffsetState){
	DGCalendarCompactWeekViewContentOffsetValid = (1 << 0),
	DGCalendarCompactWeekViewContentOffsetInvalid = (1 << 1),
	DGCalendarCompactWeekViewContentOffsetFixFromLeft = (1 << 2),
	DGCalendarCompactWeekViewContentOffsetFixFromRight = (1 << 3)
};

@interface DGCalendarCompactWeekViewLayout ()

@property NSDictionary<NSString*, NSDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>*>* layoutInfo;
@property (nonatomic) BOOL midViewExpanded;
@property BOOL layoutValid;
@property enum DGCalendarCompactWeekViewContentOffsetState contentOffsetState;

@end

@implementation DGCalendarCompactWeekViewLayout

#pragma mark - Setup

+ (Class)invalidationContextClass
{
	return [DGCalendarCompactWeekViewLayoutInvalidationContext class];
}

#pragma mark - Layout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	[self invalidateLayoutWithContext:[self invalidationContextForBoundsChange:newBounds]];
	return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (UICollectionViewLayoutInvalidationContext*)invalidationContextForBoundsChange:(CGRect)newBounds
{
	DGCalendarCompactWeekViewLayoutInvalidationContext* context = (DGCalendarCompactWeekViewLayoutInvalidationContext*)[super invalidationContextForBoundsChange:newBounds];

	if (newBounds.origin.x < WEEKS_GROUP_START_POSITION) {
		[self.delegate calendarCompactWeekViewLayout:self shiftDateForWeeks:NUMBER_OF_WEEKS * -.5];
		[self setContentOffsetState:DGCalendarCompactWeekViewContentOffsetInvalid | DGCalendarCompactWeekViewContentOffsetFixFromLeft];
		[self setLayoutValid:NO];
	} else if ((newBounds.origin.x + newBounds.size.width) > (WEEKS_GROUP_END_POSITION)) {
		[self.delegate calendarCompactWeekViewLayout:self shiftDateForWeeks:NUMBER_OF_WEEKS * .5];
		[self setContentOffsetState:DGCalendarCompactWeekViewContentOffsetInvalid | DGCalendarCompactWeekViewContentOffsetFixFromRight];
		[self setLayoutValid:NO];
	}

	return context;
}

- (void)invalidateLayoutWithContext:(DGCalendarCompactWeekViewLayoutInvalidationContext*)context
{
	[super invalidateLayoutWithContext:context];
}

- (void)prepareLayout
{
	[super prepareLayout];

	if (!self.layoutValid) {

		NSMutableDictionary<NSString*, NSDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>*>* layoutInfo = @{}.mutableCopy;

		NSMutableDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>* topViewLayoutAttrs = @{}.mutableCopy;
		NSMutableDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*>* midViewLayoutAttrs = @{}.mutableCopy;

		for (NSInteger weekIndex = 0; weekIndex < self.collectionView.numberOfSections; weekIndex++) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:weekIndex];

			UICollectionViewLayoutAttributes* topViewAttributes = [UICollectionViewLayoutAttributes
				layoutAttributesForSupplementaryViewOfKind:DGCalendarTopReusableViewKind
											 withIndexPath:indexPath];
			[topViewAttributes setZIndex:3];
			[topViewAttributes setFrame:[self frameForTopReusableViewWithIndexPath:indexPath]];

			topViewLayoutAttrs[indexPath] = topViewAttributes;

			UICollectionViewLayoutAttributes* midViewAttributes = [UICollectionViewLayoutAttributes
				layoutAttributesForSupplementaryViewOfKind:DGCalendarMidReusableViewKind
											 withIndexPath:indexPath];

			[midViewAttributes setZIndex:2];
			[midViewAttributes setFrame:[self frameForMidReusableViewWithIndexPath:indexPath]];

			midViewLayoutAttrs[indexPath] = midViewAttributes;
		}

		layoutInfo[DGCalendarTopReusableViewKind] = topViewLayoutAttrs;
		layoutInfo[DGCalendarMidReusableViewKind] = midViewLayoutAttrs;

		[self setLayoutInfo:layoutInfo];

		if (self.contentOffsetState & DGCalendarCompactWeekViewContentOffsetInvalid) {
			NSInteger sectionIndex = self.numberOfSections * .5;
			if (self.contentOffsetState & DGCalendarCompactWeekViewContentOffsetFixFromLeft) {
				sectionIndex = self.numberOfSections * .5;
			} else if (self.contentOffsetState & DGCalendarCompactWeekViewContentOffsetFixFromRight) {
				sectionIndex -= 1;
			}

			CGFloat x = [self weekStartPositionForWeekWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
			CGFloat y = self.collectionView.contentOffset.y;
			[self.collectionView setContentOffset:CGPointMake(x, y)];
			[self setContentOffsetState:DGCalendarCompactWeekViewContentOffsetValid];
		}

		[self setLayoutValid:YES];
	}
}

- (NSArray<UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray<UICollectionViewLayoutAttributes*>* layoutAttributes = @[].mutableCopy;

	for (NSString* kind in self.layoutInfo.allKeys) {
		for (NSIndexPath* indexPath in self.layoutInfo[kind].allKeys) {
			if (CGRectIntersectsRect(rect, self.layoutInfo[kind][indexPath].frame)) {
				[layoutAttributes addObject:self.layoutInfo[kind][indexPath]];
			}
		}
	}

	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath
{
	return self.layoutInfo[elementKind][indexPath];
}

#pragma mark - Frames

- (CGRect)frameForTopReusableViewWithIndexPath:(NSIndexPath*)indexPath
{
	return CGRectMake(WEEK_START_POSITION(indexPath.section),
		WEEK_VERTICAL_START_POSITION,
		WEEK_WIDTH,
		TOP_VIEW_HEIGHT);
}

- (CGRect)frameForMidReusableViewWithIndexPath:(NSIndexPath*)indexPath
{
	return CGRectMake(WEEK_START_POSITION(indexPath.section),
		MID_VIEW_VERTICAL_POSITION,
		WEEK_WIDTH,
		MID_VIEW_HEIGHT);
}

- (CGFloat)weekStartPositionForWeekWithIndexPath:(NSIndexPath*)indexPath
{
	return WEEK_START_POSITION(indexPath.section);
}

#pragma mark - Sections

- (NSInteger)numberOfSections
{
	return NUMBER_OF_WEEKS;
}

- (DGSectionEquivalent)sectionEquivalent
{
	return self.midViewExpanded ? DGSectionEquivalentMonth : DGSectionEquivalentWeek;
}

#pragma mark - Dimensions

- (CGSize)collectionViewContentSize
{
	return CONTENT_SIZE;
}

#pragma mark - Scrolling

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
	for (NSInteger weekIndex = 0; weekIndex < self.collectionView.numberOfSections; weekIndex++) {
		CGFloat weekStartPosition = WEEK_START_POSITION(weekIndex);
		CGFloat weekEndPosition = weekStartPosition + WEEK_WIDTH;

		if ((weekStartPosition < proposedContentOffset.x) && (weekEndPosition > proposedContentOffset.x)) {
			proposedContentOffset.x = velocity.x < 0 ? weekStartPosition : weekEndPosition;
			// TODO: Improve scrolling behaviour?
			//            proposedContentOffset.x = (weekStartPosition + (WEEK_WIDTH/3) < proposedContentOffset.x) ? weekEndPosition : weekStartPosition;
		}
	}

	return proposedContentOffset;
}

#pragma mark - Actions

- (void)toggleMidView
{
	DGWeakify(self);
	[self.collectionView performBatchUpdates:^{
		DGStrongify(self);
		[self setLayoutValid:NO];
		self.midViewExpanded = !self.midViewExpanded;
	}
								  completion:nil];
}

- (void)forceInvalidateLayout
{
	[self setLayoutValid:NO];
	[self invalidateLayout];
}

#pragma mark - Attributes invalidation

#pragma mark - Helpers

- (NSInteger)currentSection
{
	return self.collectionView.contentOffset.x / WEEK_WIDTH;
}

@end

@implementation UICollectionView (CalendarCompactWeekViewLayoutEasyAccess)

- (DGCalendarCompactWeekViewLayout*)compactWeekViewLayout
{
	return (DGCalendarCompactWeekViewLayout*)self.collectionViewLayout;
}

@end
