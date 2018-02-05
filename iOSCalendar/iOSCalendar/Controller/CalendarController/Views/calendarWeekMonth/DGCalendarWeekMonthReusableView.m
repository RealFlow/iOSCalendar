//
//  DGCalendarWeekMonthReusableView.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarWeekMonthReusableView.h"

@interface DGCalendarWeekMonthReusableView ()

@property (nonatomic, readonly) NSDate* startOfMonth;
@property (nonatomic, readonly) NSDate* endOfMonth;
@property (nonatomic, readonly) NSDate* prevMonthStart;
@property (nonatomic, readonly) NSDate* nextMonthStart;
@property (nonatomic, readonly) NSInteger firstWeekdayFix;
@property (nonatomic, readonly) NSInteger selectedDayIndex;
@property (nonatomic, readonly) NSInteger firstMonthDayWeekDayIndex;
@property (nonatomic, readonly) NSInteger focusMonthWeekIndex;
@property (nonatomic, readonly) NSInteger todayDayIndexInCurrentMonth;
@property (nonatomic, readonly) NSInteger numberOfDays;
@property (nonatomic, readonly) NSInteger prevMonthNumberOfDays;
@property (nonatomic, readonly) NSInteger nextMonthNumberOfDays;

@property (nonatomic, readonly) NSInteger weeksInView;
@property (nonatomic, readonly) NSInteger daysInWeek;

@property (nonatomic) NSArray<DGCalendarEvent*>* monthEvents;
@property (nonatomic) NSArray* passiveDays; // TODO: Define Passive day object/helper
@property (nonatomic) NSMutableDictionary<NSString*, NSMutableArray<DGCalendarWeekMonthDayCellEventHelper*>*>* preparedMonthEvents;

@property NSString* firstMonthDayWeekDayName;

@property (nonatomic) CGSize previousSize;

@property (strong, nonatomic, readonly) NSDate* date;
@property (strong, nonatomic) UICollectionView* collectionView;
@property (nonatomic) DGCalendarWeekMonthReusableViewDateRange* dateRange;

@end

@implementation DGCalendarWeekMonthReusableView

#pragma mark - View Lifecycle Methods

- (void)awakeFromNib
{
	[super awakeFromNib];

	[self initializePreProcessing];
	[self initializeCollection];
	[self initializeObservers];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initUserInterface];
		[self initializePreProcessing];
		[self initializeCollection];
		[self initializeObservers];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization Methods

- (void)initUserInterface
{
    _monthViewBackgroundColor = _monthViewBackgroundColor ? : [UIColor clearColor];
    
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[DGCalendarWeekMonthViewLayout new]];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	if ([_collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
		_collectionView.prefetchingEnabled = YES;
	}
	_collectionView.backgroundColor = self.monthViewBackgroundColor;
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_collectionView];
	[_collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
	[_collectionView.heightAnchor constraintEqualToConstant:250].active = YES;
	[_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
	[_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)initializePreProcessing
{
	_preparedMonthEvents = @{}.mutableCopy;
	_weeksInView = [self.collectionView.calendarWeekMonthViewLayout numberOfSections];
	_daysInWeek = [self.collectionView.calendarWeekMonthViewLayout numberOfRows];
}

- (void)initializeCollection
{
	[self.collectionView registerClass:[DGCalendarWeekMonthDayCell class]
			forCellWithReuseIdentifier:[DGCalendarWeekMonthDayCell reuseIdentifier]];

	[self.collectionView registerClass:[DGCalendarWeekMonthDayNameView class]
			forSupplementaryViewOfKind:DGCalendarWeekMonthDayNameViewKind
				   withReuseIdentifier:[DGCalendarWeekMonthDayNameView reuseIdentifier]];
}

- (void)initializeObservers
{
	DGWeakify(self);
	[[NSNotificationCenter defaultCenter] addObserverForName:kDGCalendarWeekMonthReusableViewUpdateLayoutMode
													  object:nil
													   queue:[NSOperationQueue mainQueue]
												  usingBlock:^(NSNotification* _Nonnull note) {
													  DGStrongify(self);
													  DGWeakify(self);
													  [self.collectionView performBatchUpdates:^{
														  DGStrongify(self);
														  [self.collectionView.calendarWeekMonthViewLayout setMode:[note.object integerValue]];
													  }
																					completion:nil];
												  }];
}

- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
{
	return layoutAttributes;
}

#pragma mark - Update Methods

+ (void)updateAllCalendarWeekMonthReusableViewsWithNewMode:(DGCalendarMode)mode
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kDGCalendarWeekMonthReusableViewUpdateLayoutMode object:@(mode)];
}

- (void)updateWithDataModel:(DGCalendarWeekMonthReusableViewDataModel*)dataModel
{
	[self setDate:dataModel.date];
	[self setMonthEvents:dataModel.events];
	[self setPassiveDays:dataModel.passiveDays];

	if (self.collectionView.calendarWeekMonthViewLayout.mode != dataModel.mode) {
		[self.collectionView.calendarWeekMonthViewLayout setMode:dataModel.mode];
	}

	[self.collectionView reloadData];
}

#pragma mark - Accessors

- (void)setDate:(NSDate*)date
{
	_date = date;
	_selectedDayIndex = _date.day - 1;

	_startOfMonth = _date.firstDayOfMonth.startOfDay;
	_endOfMonth = _date.lastDayOfMonth.endOfDay;
	_prevMonthStart = _date.previousMonth.firstDayOfMonth.startOfDay;
	_nextMonthStart = _date.nextMonth.firstDayOfMonth.startOfDay;

	_numberOfDays = [NSDate.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_date].length;
	_prevMonthNumberOfDays = [NSDate.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_prevMonthStart].length;
	_nextMonthNumberOfDays = [NSDate.currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_nextMonthStart].length;

	_firstWeekdayFix = [NSDate currentCalendar].firstWeekday - 1;
	_firstMonthDayWeekDayIndex = _startOfMonth.weekday - 1;
	_firstMonthDayWeekDayIndex = _firstMonthDayWeekDayIndex ?: 7; // Sunday fix (moves index to the end of week)

	/********************************************************************************
    * [NSDateComponents weekDay] -> Weekday units are the numbers 1 through n, where n is the number of days in the week. For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
     +---------+--------+---------+-----------+----------+--------+-----------+
     |    1    |    2   |    3    |     4     |     5    |    6   |     7     |
     |  sunday | monday | tuesday | wednesday | thursday | friday | saturday  |
     +---------+--------+---------+-----------+----------+--------+-----------+

    *********************************************************************************/

	NSDate* today = [NSDate now];

	if ([today isBetweenDate:_startOfMonth andDate:_startOfMonth.endOfMonth])
		_todayDayIndexInCurrentMonth = [_startOfMonth daysBeforeDate:today];
	else if ([today isBetweenDate:_prevMonthStart andDate:_prevMonthStart.endOfMonth])
		_todayDayIndexInCurrentMonth = -([today daysBeforeDate:_startOfMonth]);
	else if ([today isBetweenDate:_nextMonthStart andDate:_nextMonthStart.endOfMonth])
		_todayDayIndexInCurrentMonth = [_startOfMonth daysBeforeDate:today];
	else
		_todayDayIndexInCurrentMonth = NSIntegerMin;

	for (NSInteger weekIndex = 0; weekIndex < _weeksInView; weekIndex++) {
		for (NSInteger weekDayIndex = 0; weekDayIndex < _daysInWeek; weekDayIndex++) {

			NSInteger cellIndex = weekIndex * _daysInWeek + weekDayIndex + _firstWeekdayFix;
			NSInteger dayIndexInCurrentMonth = cellIndex - self.firstMonthDayWeekDayIndex;

			if (dayIndexInCurrentMonth == self.selectedDayIndex) {
				_focusMonthWeekIndex = weekIndex;
				break;
			}
		}
	}

	[self.collectionView.calendarWeekMonthViewLayout setFocusWeekIndex:_focusMonthWeekIndex];
}

- (void)setMonthEvents:(NSArray<DGCalendarEvent*>*)monthEvents
{
	_monthEvents = monthEvents;

	[self.preparedMonthEvents removeAllObjects];

	for (DGCalendarEvent* event in monthEvents) {

		DGCalendarWeekMonthDayCellEventHelper* eventHelper = [DGCalendarWeekMonthDayCellEventHelper new];
		eventHelper.color = event.eventColor ?: [UIColor darkGrayColor];

		NSMutableArray<NSString*>* eventDurationDays = @[].mutableCopy;

		NSDate* startDate = [event.startDate startOfDay];
		NSDate* endDate = [event.endDate endOfDay];

		NSInteger durationDays = [startDate daysBeforeDate:endDate];

		do {
			NSDate* partialDate = [startDate dateByAddingDays:durationDays];
			[eventDurationDays addObject:[partialDate shortDateString]];
			durationDays--;
		} while (durationDays >= 0);

		for (NSString* eventDay in eventDurationDays) {
			NSMutableArray* storedEvents;
			if ([self.preparedMonthEvents objectForKey:eventDay])
				storedEvents = [self.preparedMonthEvents objectForKey:eventDay];
			else
				storedEvents = @[].mutableCopy;

			[storedEvents addObject:eventHelper];

			[self.preparedMonthEvents setObject:storedEvents forKey:eventDay];
		}
	}
}

#pragma mark - Helper Methods

- (DGCalendarWeekMonthReusableViewDateRange*)dateRangeForDate:(NSDate*)date
{
	DGCalendarWeekMonthReusableViewDateRange* range = [DGCalendarWeekMonthReusableViewDateRange new];

	NSDate* startOfMonth = date.firstDayOfMonth.startOfDay;
	NSInteger firstMonthDayWeekDayIndex = startOfMonth.weekday - 1;

	for (NSInteger weekIndex = 0; weekIndex < _weeksInView; weekIndex++) {
		for (NSInteger weekDayIndex = 0; weekDayIndex < _daysInWeek; weekDayIndex++) {

			NSInteger cellIndex = weekIndex * _daysInWeek + weekDayIndex + _firstWeekdayFix;
			NSInteger dayIndexInCurrentMonth = cellIndex - firstMonthDayWeekDayIndex;

			NSDate* cellDate = [startOfMonth dateByAddingDays:dayIndexInCurrentMonth];

			if (!range.startDate || !range.endDate) {
				range.startDate = cellDate;
				range.endDate = cellDate;
			} else {
				range.startDate = [cellDate.startOfDay isEarlierThanDate:range.startDate] ? cellDate.startOfDay : range.startDate;
				range.endDate = [cellDate.endOfDay isLaterThanDate:range.endDate] ? cellDate.endOfDay : range.endDate;
			}
		}
	}

	self.dateRange = range;

	return range;
}

- (NSArray<DGCalendarWeekMonthDayCellEventHelper*>*)eventsForDate:(NSDate*)date
{
	return [self.preparedMonthEvents objectForKey:[date shortDateString]];
}

#pragma mark - UICollectionViewDataSource + UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
	return [collectionView.calendarWeekMonthViewLayout numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [collectionView.calendarWeekMonthViewLayout numberOfRows];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
	DGCalendarWeekMonthDayCell* cell = (DGCalendarWeekMonthDayCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[DGCalendarWeekMonthDayCell reuseIdentifier] forIndexPath:indexPath];

	[self updateCell:cell withIndexPath:indexPath];

	return cell;
}

- (void)updateCell:(DGCalendarWeekMonthDayCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
	NSInteger weekIndex = indexPath.section;
	NSInteger weekDayIndex = indexPath.item;
	NSInteger cellIndex = weekIndex * _daysInWeek + weekDayIndex + _firstWeekdayFix;
	NSInteger dayIndexInCurrentMonth = cellIndex - self.firstMonthDayWeekDayIndex;

	BOOL isPrevMonth = dayIndexInCurrentMonth < 0;
	BOOL isNextMonth = (dayIndexInCurrentMonth) >= self.numberOfDays;
	BOOL isCurrentMonth = (self.firstMonthDayWeekDayIndex <= cellIndex) && !isNextMonth;

	NSDate* cellDate = [self.startOfMonth dateByAddingDays:dayIndexInCurrentMonth];

	DGCalendarWeekMonthDayCellStyleOptions options = DGCalendarWeekMonthDayCellStyleNormal;

	if (isPrevMonth || isNextMonth) {
		options |= DGCalendarWeekMonthDayCellStyleOtherMonth;
	}

	BOOL isFocusWeek = weekIndex == self.focusMonthWeekIndex;

	if (isFocusWeek) {
		options |= DGCalendarWeekMonthDayCellStyleCurrentWeek;
	}

	BOOL isSelectedDay = dayIndexInCurrentMonth == self.selectedDayIndex;

	if (isSelectedDay) {
		options |= DGCalendarWeekMonthDayCellStyleSelected;
	}

	BOOL isToday = dayIndexInCurrentMonth == self.todayDayIndexInCurrentMonth;

	if (isToday) {
		options |= DGCalendarWeekMonthDayCellStyleToday;
	}

	[cell updateWithDate:cellDate];
	[cell updateWithMonthDayEvents:[self eventsForDate:cellDate] showRealColor:isCurrentMonth];
	[cell updateWithOptions:options];
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
	DGCalendarWeekMonthDayNameView* view = (DGCalendarWeekMonthDayNameView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DGCalendarWeekMonthDayNameView reuseIdentifier] forIndexPath:indexPath];
	[view updateWithWeekDayIndex:indexPath.item];

	return view;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
	DGCalendarWeekMonthDayCell* cell = (DGCalendarWeekMonthDayCell*)[collectionView cellForItemAtIndexPath:indexPath];

	if (self.delegate)
		[self.delegate calendarWeekMonthReusableView:self didSelectDate:cell.date];
}

@end

@implementation DGCalendarWeekMonthReusableViewDateRange
@end

@implementation DGCalendarWeekMonthReusableViewDataModel
@end
