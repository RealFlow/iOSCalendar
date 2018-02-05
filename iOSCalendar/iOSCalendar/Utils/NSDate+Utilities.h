//
//  NSDate+Additions.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_SECOND 1
#define D_MINUTE 60
#define D_HOUR 3600
#define D_DAY 86400
#define D_WEEK 604800
#define D_YEAR 31556926

@interface NSDate (Utilities)

#pragma mark - Class Methods

+ (NSCalendar*)currentCalendar;

+ (NSDate*)now;
+ (NSDate*)yesterday;
+ (NSDate*)tomorrow;
+ (NSDate*)midnight;
+ (NSUInteger)weekStartsWithDay;
+ (NSUInteger)weekEndsWithDay;

// Date Operations
+ (NSDate*)dateByAddingYears:(NSInteger)years;
+ (NSDate*)dateByAddingMonths:(NSInteger)months;
+ (NSDate*)dateByAddingWeeks:(NSInteger)weeks;
+ (NSDate*)dateByAddingDays:(NSInteger)days;
+ (NSDate*)dateByAddingHours:(NSInteger)hours;
+ (NSDate*)dateByAddingMinutes:(NSInteger)minutes;
+ (NSDate*)dateByAddingSeconds:(NSInteger)seconds;

+ (NSDate*)dateBySubtractingYears:(NSInteger)years;
+ (NSDate*)dateBySubtractingMonths:(NSInteger)months;
+ (NSDate*)dateBySubtractingWeeks:(NSInteger)weeks;
+ (NSDate*)dateBySubtractingDays:(NSInteger)days;
+ (NSDate*)dateBySubtractingHours:(NSInteger)hours;
+ (NSDate*)dateBySubtractingMinutes:(NSInteger)minutes;
+ (NSDate*)dateBySubtractingSeconds:(NSInteger)seconds;

// Date Comparison
+ (NSDate*)mediumDateBetweenDate:(NSDate*)date andDate:(NSDate*)secondDate;
+ (NSInteger)hoursBetween:(NSDate*)firstDate and:(NSDate*)secondDate;

#pragma mark - Instance Methods

// Date Decomposing
@property (readonly) NSInteger year;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger day;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger nanoseconds;

// Date Strings

- (NSString*)stringWithFormat:(NSString*)format;
- (NSString*)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSString*)shortDateString;
- (NSString*)shortTimeString;
- (NSString*)shortDateTimeString;
- (NSString*)mediumDateString;
- (NSString*)mediumTimeString;
- (NSString*)mediumDateTimeString;
- (NSString*)longDateString;
- (NSString*)longTimeString;
- (NSString*)longDateTimeString;
- (NSString*)longDateShortTimeString;

- (NSString*)customShortMonthAndDayString;
- (NSString*)customShortMonthAndYearString;
- (NSString*)customShortWeekdayAndDayString;
- (NSString*)customLongMonthAndYearString;
- (NSString*)customLongMonthDayYearString;
- (NSString*)customLongWeekdayString;
- (NSString*)customLongWeekdayAndDayString;
- (NSString*)customLongWeekdayMonthDayYearString;

- (NSDate*)convertToUTCDate;

// Date Comparison
- (BOOL)isEqualToDateIgnoringTime:(NSDate*)aDate;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;

- (BOOL)isSameWeekAsDate:(NSDate*)aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;

- (BOOL)isSameMonthAsDate:(NSDate*)aDate;
- (BOOL)isSameDayAsDate:(NSDate*)aDate;
- (BOOL)isThisMonth;
- (BOOL)isNextMonth;
- (BOOL)isLastMonth;

- (BOOL)isSameYearAsDate:(NSDate*)aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;

- (BOOL)isInFuture;
- (BOOL)isInPast;

// Date Roles
- (BOOL)isTypicallyWorkday;
- (BOOL)isTypicallyWeekend;

// Date Operations
- (NSDate*)dateByAddingYears:(NSInteger)years;
- (NSDate*)dateByAddingMonths:(NSInteger)months;
- (NSDate*)dateByAddingWeeks:(NSInteger)weeks;
- (NSDate*)dateByAddingDays:(NSInteger)days;
- (NSDate*)dateByAddingHours:(NSInteger)hours;
- (NSDate*)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate*)dateByAddingSeconds:(NSInteger)seconds;

- (NSDate*)dateBySubtractingYears:(NSInteger)years;
- (NSDate*)dateBySubtractingMonths:(NSInteger)months;
- (NSDate*)dateBySubtractingWeeks:(NSInteger)weeks;
- (NSDate*)dateBySubtractingDays:(NSInteger)days;
- (NSDate*)dateBySubtractingHours:(NSInteger)hours;
- (NSDate*)dateBySubtractingMinutes:(NSInteger)minutes;
- (NSDate*)dateBySubtractingSeconds:(NSInteger)seconds;

- (NSDate*)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

- (NSDate*)dateBySettingHour:(NSInteger)h minute:(NSInteger)m second:(NSInteger)s;

- (NSDate*)dateByRoundingUp;
- (NSDate*)nextDay;
- (NSDate*)previousDay;
- (NSDate*)nextWeek;
- (NSDate*)previousWeek;
- (NSDate*)nextMonth;
- (NSDate*)previousMonth;
- (NSDate*)startOfDay;
- (NSDate*)endOfDay;
- (NSDate*)midnight;
- (NSDate*)firstDayOfWeek;
- (NSDate*)lastDayOfWeek;
- (NSDate*)firstDayOfMonth;
- (NSDate*)lastDayOfMonth;
- (NSDate*)startOfWeek;
- (NSDate*)endOfWeek;
- (NSDate*)startOfMonth;
- (NSDate*)endOfMonth;
- (NSDate*)dateWithDay:(NSUInteger)day direction:(NSComparisonResult)direction includeCurrent:(BOOL)includeCurrent;
- (NSDate*)startOfWeekend;
- (NSDate*)endOfWeekend;

- (NSDateComponents*)componentsWithOffsetFromDate:(NSDate*)aDate;

- (NSDate*)dateAtStartOfWeek;
- (NSDate*)dateAtStartOfMonth;
- (NSDate*)dateAtNearest5Minute;
- (NSDate*)dateWithCurrentTime;

// Date Intervals
- (NSInteger)daysAfterDate:(NSDate*)aDate;
- (NSInteger)daysBeforeDate:(NSDate*)aDate;
- (NSInteger)hoursAfterDate:(NSDate*)aDate;
- (NSInteger)hoursBeforeDate:(NSDate*)aDate;
- (NSInteger)minutesAfterDate:(NSDate*)aDate;
- (NSInteger)minutesBeforeDate:(NSDate*)aDate;
- (NSInteger)secondsAfterDate:(NSDate*)aDate;
- (NSInteger)secondsBeforeDate:(NSDate*)aDate;

- (NSInteger)distanceInDaysToDate:(NSDate*)anotherDate;

// Date Comparison
- (BOOL)isEarlierThanDate:(NSDate*)aDate;
- (BOOL)isLaterThanDate:(NSDate*)aDate;
- (BOOL)isEarlierOrEqualToDate:(NSDate*)aDate;
- (BOOL)isLaterOrEqualToDate:(NSDate*)aDate;
- (BOOL)isBetweenDate:(NSDate*)startDate andDate:(NSDate*)endDate;

@end

@interface NSDateFormatter (Utilities)

+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat;
+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat locale:(NSLocale*)locale;
+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat locale:(NSLocale*)locale timeZone:(NSTimeZone*)timeZone;

@end
