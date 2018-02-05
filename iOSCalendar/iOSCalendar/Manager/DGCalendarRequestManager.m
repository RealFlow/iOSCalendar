//
//  DGCalendarRequestManager.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarRequestManager.h"
#import "DGMainViewController.h"
#import "DGCalendarEvent.h"

typedef NS_ENUM(NSInteger, PRECalendarType) {
	PRECalendarTypeMonth,
	PRECalendarTypeWeek
};

@interface DGCalendarRequestManager ()

@property (nonatomic, strong) DGMainViewControllerDM* calendarDM;
@property (nonatomic, strong) NSDate* higherRequestedDate;
@property (nonatomic, strong) NSDate* lowerRequestedDate;

@end

@implementation DGCalendarRequestManager

#pragma mark - Initialization

- (instancetype)initWithCalendarDataModel:(DGMainViewControllerDM*)calendarDM
{
	self = [super init];

	if (self) {
		_calendarDM = calendarDM;
		_numberOfBufferedMonths = 1;
	}

	return self;
}

#pragma mark - Public

- (void)requestEventsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    if ([self didAlreadyRequestedEventsFromDate:fromDate toDate:toDate]) {
        
        if (self.calendarRequestDelegate) {
            [self.calendarRequestDelegate calendarRequestManager:self didReceiveEventsfromDate:fromDate toDate:toDate];
        }
        
    } else {
        
        if (self.calendarRequestDelegate) {
            [self.calendarRequestDelegate calendarRequestManager:self didReceiveEventsfromDate:fromDate toDate:toDate];
        }
        
    }
}

- (void)requestEventsForMonthContainingDate:(NSDate*)dateWithinMonth
{
	//Ideally if the server will respect the range requested this could be done with just one call.
	// But the current behaviour is tha the server returns the month events for the month that contains the start dates
	// so we need (kNumberOfBufferedMonths*2)+1 calls. Hopefully we can change this in the future

	//current month
	[self requestEventsFromDate:dateWithinMonth.firstDayOfMonth toDate:dateWithinMonth.lastDayOfMonth];

	for (int i = 0; i < self.numberOfBufferedMonths; i++) {

		//previous month request
		NSDate* prev = [dateWithinMonth dateByAddingMonths:self.numberOfBufferedMonths];
		[self requestEventsFromDate:prev.firstDayOfMonth toDate:prev.lastDayOfMonth];

		//next month request
		NSDate* next = [dateWithinMonth dateBySubtractingMonths:self.numberOfBufferedMonths];
		[self requestEventsFromDate:next.firstDayOfMonth toDate:next.lastDayOfMonth];
	}
}

#pragma mark - Helpers

- (BOOL)didAlreadyRequestedEventsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    if (!self.lowerRequestedDate && !self.higherRequestedDate) {
        self.lowerRequestedDate = fromDate;
        self.higherRequestedDate = toDate;
        return NO;
    }
    
    if ([fromDate isEarlierThanDate:self.lowerRequestedDate]) {
        self.lowerRequestedDate = fromDate;
        return NO;
    }
    
    if ([toDate isLaterThanDate:self.higherRequestedDate]) {
        self.higherRequestedDate = toDate;
        return NO;
    }
    
    return YES;
}


- (NSArray<DGCalendarEvent*>*)filterEvents:(NSArray<DGCalendarEvent*>*)events fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
	return [events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", toDate, fromDate]];
}

@end
