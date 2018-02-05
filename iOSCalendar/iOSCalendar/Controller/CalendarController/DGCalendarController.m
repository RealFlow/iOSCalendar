//
//  DGCalendarController.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarController.h"

#define kCalendarHeightForWeekMode 100
#define kCalendarHeightForMonthMode 270

@interface DGCalendarController ()

@property (nonatomic, strong) NSArray* activities;
@property (nonatomic, strong) NSDate* selectedDate;
@property (nonatomic, strong) NSDate* selectedDateBackUp;
@property (nonatomic, assign) DGCalendarMode calendarMode;

@property (weak, nonatomic) IBOutlet DGCalendarCompactWeekView* collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* spinner;

@property BOOL requiresReload;

@end

@implementation DGCalendarController

@synthesize selectedDate = _selectedDate;

+ (CGFloat)heightForMode:(DGCalendarMode)mode
{
	if (mode == kDGCalendarModeWeek)
		return kCalendarHeightForWeekMode;
	else
		return kCalendarHeightForMonthMode;
}

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self initializePreprocessing];
	[self initializeSpinner];
	[self initializeCollection];
}

#pragma mark - Initialization Methods

- (void)initializePreprocessing
{
	_selectedDate = [NSDate now];
}

- (void)initializeSpinner
{
	CGAffineTransform transform = CGAffineTransformMakeScale(.5f, .5f);
	self.spinner.transform = transform;
	[self updateWithUIMode:kDGCalendarUIModeDEFAULT];
}

- (void)initializeCollection
{
	DGCalendarCompactWeekView* collectionView = self.collectionView;

	[collectionView registerClass:[DGCalendarFilterBarReusableView class]
		forSupplementaryViewOfKind:DGCalendarTopReusableViewKind
			   withReuseIdentifier:[DGCalendarFilterBarReusableView reuseIdentifier]];

	[collectionView registerClass:[DGCalendarWeekMonthReusableView class]
		forSupplementaryViewOfKind:DGCalendarMidReusableViewKind
			   withReuseIdentifier:[DGCalendarWeekMonthReusableView reuseIdentifier]];

	collectionView.compactWeekViewLayout.delegate = self;

	[self reportHeight];
}

#pragma mark - Update Methods

- (void)updateWithSelectedDate:(NSDate*)selectedDate
{
	if (selectedDate) {
		self.selectedDate = selectedDate;
		self.selectedDateBackUp = nil;
		[self reload];
	}
}

- (void)updateWithMode:(DGCalendarMode)mode
{
	if (self.calendarMode != mode)
		[self switchMode];
}

- (void)updateWithUIMode:(DGCalendarUIMode)uiMode
{
	switch (uiMode) {
	case kDGCalendarUIModeProcessing: {
		[self showSpinner];
	} break;
	default: {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSpinner) object:nil];
		[self performSelector:@selector(hideSpinner) withObject:nil afterDelay:.6f];
	} break;
	}
}

- (void)reload
{
	[self reloadData];
	[self reloadLayout];
}

- (void)reloadLayout
{
	[self.collectionView setNeedsLayout];
	self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentOffset.y);
	[self.collectionView.compactWeekViewLayout forceInvalidateLayout];
	[self.collectionView.calendarWeekMonthViewLayout invalidateLayout];

	[self.collectionView layoutIfNeeded];
	[DGCalendarWeekMonthReusableView updateAllCalendarWeekMonthReusableViewsWithNewMode:self.calendarMode];
	[self.collectionView layoutIfNeeded];
}

- (void)reloadData
{
	[self.collectionView reloadData];
}

- (void)delayedReloadData
{
	//    NSLog(@" ----> RELOAD DATA delayed <---- ");
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
	[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (void)smartReloadData
{
	if (!self.collectionView.isDecelerating || !self.collectionView.isDragging) {
		[self delayedReloadData];
	} else {
		self.requiresReload = YES;
	}
}

#pragma mark - Accessors

- (NSDate*)selectedDate
{
	return _selectedDate;
}

- (void)setSelectedDate:(NSDate*)selectedDate
{
	if (_selectedDate != selectedDate)
		_selectedDate = selectedDate;

	[self reportSelectedDate:_selectedDate];
}

#pragma mark - Helper Methods

- (NSDate*)helperDateForSwitchMode
{
	return [[self selectedDateByAddingUnits:self.collectionView.compactWeekViewLayout.currentSection] dateWithCurrentTime];
}

- (void)switchMode
{
	self.selectedDate = [self helperDateForSwitchMode];

	DGCalendarCompactWeekView* collectionView = self.collectionView;
	collectionView.contentOffset = CGPointMake(0, collectionView.contentOffset.y);
	[collectionView reloadData];
	[collectionView.compactWeekViewLayout toggleMidView];

	self.calendarMode = [self isMonthMode] ? kDGCalendarModeMonth : kDGCalendarModeWeek;

	[DGCalendarWeekMonthReusableView updateAllCalendarWeekMonthReusableViewsWithNewMode:self.calendarMode];

	[self reportMode];
	[self reportHeight];
}

- (BOOL)isMonthMode
{
	return self.collectionView.compactWeekViewLayout.midViewExpanded;
}

- (NSDate*)date:(NSDate*)date byAddingUnits:(NSInteger)unit
{
	return [self isMonthMode] ? [date dateByAddingMonths:unit] : [date dateByAddingWeeks:unit];
}

- (NSDate*)date:(NSDate*)date bySubtractingUnits:(NSInteger)unit
{
	return [self date:date byAddingUnits:(-1) * unit];
}

- (NSDate*)selectedDateByAddingUnits:(NSInteger)unit
{
	return [self date:self.selectedDate byAddingUnits:unit];
}

- (NSDate*)selectedDateBySubtractingUnits:(NSInteger)unit
{
	return [self date:self.selectedDate bySubtractingUnits:unit];
}

- (void)showSpinner
{
	if (![self.spinner isAnimating]) {
		[self.spinner setHidden:NO];
		[self.spinner startAnimating];
	}
}

- (void)hideSpinner
{
	if ([self.spinner isAnimating]) {
		[self.spinner stopAnimating];
		[self.spinner setHidden:YES];
	}
}

#pragma mark - Helper Methods (Report)

- (void)reportMode
{
	if (self.delegate)
		[self.delegate calendarController:self requiresMode:self.calendarMode];
}

- (void)reportHeight
{
	if (self.delegate) {
		CGFloat height = [self isMonthMode] ? kCalendarHeightForMonthMode : kCalendarHeightForWeekMode;
		CGSize size = CGSizeMake(self.view.frame.size.width, height);
		[self.delegate calendarController:self didChangeSize:size];
	}
}

- (void)reportSelectedDate:(NSDate*)date
{
	if (self.delegate)
		[self.delegate calendarController:self didChangeSelectedDate:date];
}

- (void)reportFocusedDate:(NSDate*)date
{
	if (self.delegate)
		[self.delegate calendarController:self didChangeFocusedDate:date];
}

#pragma mark - UICollectionViewDataSource + UICollectionView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	if (self.requiresReload) {
		self.requiresReload = NO;
		[self delayedReloadData];
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
	return [collectionView compactWeekViewLayout].numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
	return nil;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
	UICollectionReusableView* reusableView = nil;
	NSDate* date = [self selectedDateByAddingUnits:indexPath.section];

	/***************************************************************
    * DG: Fixes a day precision loss.(i.e indexPath.section == months == 3)
    * 31July - 3Months = 30April    - (void)calendarWeekMonthReusableView:didSelectDate:
    * 30April + 3Months = 30July    - (UICollectionReusableView*)collectionView:viewForSupplementaryElementOfKind:atIndexPath:
    * --------------------------
    * 30July != 31 July . 31 July would get unselectable
    *******************************************************************/
	if ([self isMonthMode] && _selectedDateBackUp && [date isSameMonthAsDate:_selectedDateBackUp])
		date = _selectedDateBackUp;

	if ([kind isEqualToString:DGCalendarTopReusableViewKind]) {
		DGCalendarFilterBarReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DGCalendarFilterBarReusableView reuseIdentifier] forIndexPath:indexPath];
		[view setDelegate:self];
		[view setIndexPath:indexPath];
		[view updateWithDate:date];

		reusableView = view;

	} else if ([kind isEqualToString:DGCalendarMidReusableViewKind]) {
		DGCalendarWeekMonthReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DGCalendarWeekMonthReusableView reuseIdentifier] forIndexPath:indexPath];

		[view setDelegate:self];
		[view setIndexPath:indexPath];

		DGCalendarWeekMonthReusableViewDateRange* dateRange = [view dateRangeForDate:date];

		NSArray* events;
		NSArray* passiveDays;
		if (self.delegate) {
			events = [self.delegate calendarController:self requiresEventsFrom:dateRange.startDate to:dateRange.endDate];
			passiveDays = [self.delegate calendarController:self requiresPassiveDaysFrom:dateRange.startDate to:dateRange.endDate];
		}

		DGCalendarWeekMonthReusableViewDataModel* dataModel = [DGCalendarWeekMonthReusableViewDataModel new];
		dataModel.date = date;
		dataModel.mode = self.calendarMode;
		dataModel.events = events ?: @[];
		dataModel.passiveDays = passiveDays ?: @[];

		[view updateWithDataModel:dataModel];

		reusableView = view;
	}

	return reusableView;
}

- (void)collectionView:(UICollectionView*)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView*)view forElementOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath*)indexPath
{
	NSInteger currentSection = self.collectionView.compactWeekViewLayout.currentSection;
	NSDate* date = [self selectedDateByAddingUnits:currentSection];

	/***************************************************************
     * DG: Fixes a day precision loss.(i.e indexPath.section == months == 3)
     * 31July - 3Months = 30April    - (void)calendarWeekMonthReusableView:didSelectDate:
     * 30April + 3Months = 30July    - (UICollectionReusableView*)collectionView:viewForSupplementaryElementOfKind:atIndexPath:
     * --------------------------
     * 30July != 31 July . 31 July would get unselectable
     *******************************************************************/
	if ([self isMonthMode] && _selectedDateBackUp && [date isSameMonthAsDate:_selectedDateBackUp])
		date = _selectedDateBackUp;

	[self reportFocusedDate:date];
}

#pragma mark - DGCalendarCompactWeekViewLayout Delegate Methods

- (void)calendarCompactWeekViewLayout:(DGCalendarCompactWeekViewLayout*)layout shiftDateForWeeks:(NSInteger)weeks
{
	self.selectedDate = [self selectedDateByAddingUnits:weeks];
}

#pragma mark - DGCalendarFilterBarReusableView Delegate Methods

- (void)didTapLabelsInFilterBar:(DGCalendarFilterBarReusableView*)bar
{
	[self switchMode];
}

#pragma mark - DGCalendarWeekMonthReusableView Delegate Methods

- (void)calendarWeekMonthReusableView:(DGCalendarWeekMonthReusableView*)view didSelectDate:(NSDate*)date
{
	_selectedDateBackUp = date;
	if (![date.startOfDay isEqualToDate:self.selectedDate.startOfDay]) {
		self.selectedDate = [self date:date bySubtractingUnits:view.indexPath.section];
		[self.collectionView reloadData];
	} else {
		self.selectedDate = self.selectedDate; //  DG: Unifies delegation flow
	}
}

@end
