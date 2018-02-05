//
//  DGCalendarRequestManager.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGMainViewControllerDM.h"
#import "DGCalendarEvent.h"
#import <Foundation/Foundation.h>

@class DGCalendarRequestManager;

@protocol DGCalendarRequestDelegate <NSObject>
@required
//updates the data model passed on the creation
- (void)calendarRequestManager:(DGCalendarRequestManager*)calendarRequestManager didReceiveEventsfromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
@end

@interface DGCalendarRequestManager : NSObject

@property (nonatomic, weak) id<DGCalendarRequestDelegate> calendarRequestDelegate;

//number of months (above and below) from current month to be cached (default 1)
@property (nonatomic, assign) NSInteger numberOfBufferedMonths;

- (instancetype)initWithCalendarDataModel:(DGMainViewControllerDM*)calendarDM;
- (void)requestEventsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
- (void)requestEventsForMonthContainingDate:(NSDate*)dateWithinMonth;
@end
