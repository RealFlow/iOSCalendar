//
//  NSDate+Additions.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "NSDate+Utilities.h"

static const unsigned componentFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

static NSDateFormatter* _utcDateFormatter;

@implementation NSDate (Utilities)

#pragma mark - Class Methods

+ (NSCalendar*)currentCalendar
{
	static NSCalendar* sharedCalendar = nil;
	if (!sharedCalendar) {
		sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
		sharedCalendar.locale = [NSLocale currentLocale];
		sharedCalendar.timeZone = [NSTimeZone localTimeZone];
	}
	return sharedCalendar;
}

+ (NSDate*)now
{
	return [NSDate date];
}

+ (NSDate*)yesterday
{
	return [[NSDate now] previousDay];
}

+ (NSDate*)tomorrow
{
	return [[NSDate now] nextDay];
}

+ (NSDate*)midnight
{
	return [[NSDate now] endOfDay];
}

+ (NSUInteger)weekStartsWithDay
{
	return 1;
}

+ (NSUInteger)weekEndsWithDay
{
	return 7;
}

#pragma mark - Relative Dates

+ (NSDate*)dateByAddingYears:(NSInteger)years
{
	return [[NSDate now] dateByAddingYears:years];
}
+ (NSDate*)dateByAddingMonths:(NSInteger)months
{
	return [[NSDate now] dateByAddingMonths:months];
}
+ (NSDate*)dateByAddingWeeks:(NSInteger)weeks
{
	return [[NSDate now] dateByAddingWeeks:weeks];
}
+ (NSDate*)dateByAddingDays:(NSInteger)days
{
	return [[NSDate now] dateByAddingDays:days];
}
+ (NSDate*)dateByAddingHours:(NSInteger)hours
{
	return [[NSDate now] dateByAddingHours:hours];
}
+ (NSDate*)dateByAddingMinutes:(NSInteger)minutes
{
	return [[NSDate now] dateByAddingMinutes:minutes];
}
+ (NSDate*)dateByAddingSeconds:(NSInteger)seconds
{
	return [[NSDate now] dateByAddingSeconds:seconds];
}
+ (NSDate*)dateBySubtractingYears:(NSInteger)years
{
	return [[NSDate now] dateBySubtractingYears:years];
}
+ (NSDate*)dateBySubtractingMonths:(NSInteger)months
{
	return [[NSDate now] dateBySubtractingMonths:months];
}
+ (NSDate*)dateBySubtractingWeeks:(NSInteger)weeks
{
	return [[NSDate now] dateBySubtractingWeeks:weeks];
}
+ (NSDate*)dateBySubtractingDays:(NSInteger)days
{
	return [[NSDate now] dateBySubtractingDays:days];
}
+ (NSDate*)dateBySubtractingHours:(NSInteger)hours
{
	return [[NSDate now] dateBySubtractingHours:hours];
}
+ (NSDate*)dateBySubtractingMinutes:(NSInteger)minutes
{
	return [[NSDate now] dateBySubtractingMinutes:minutes];
}
+ (NSDate*)dateBySubtractingSeconds:(NSInteger)seconds
{
	return [[NSDate now] dateBySubtractingSeconds:seconds];
}

+ (NSDate*)mediumDateBetweenDate:(NSDate*)date andDate:(NSDate*)secondDate
{
	switch ([date compare:secondDate]) {
	case NSOrderedAscending: {
		NSTimeInterval difference = [secondDate timeIntervalSinceDate:date];
		NSDate* middle = [NSDate dateWithTimeInterval:difference / 2 sinceDate:date];
		return middle;
	}
	case NSOrderedDescending: {
		NSTimeInterval difference = [date timeIntervalSinceDate:secondDate];
		NSDate* middle = [NSDate dateWithTimeInterval:difference / 2 sinceDate:secondDate];
		return middle;
	}
	case NSOrderedSame:
		return date;
		break;
	}
}

+ (NSInteger)hoursBetween:(NSDate*)firstDate and:(NSDate*)secondDate
{
	NSUInteger unitFlags = NSCalendarUnitHour;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
	return [components hour];
}

#pragma mark - Instance Methods

#pragma mark - Decomposing Dates

- (NSInteger)year
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.year;
}

- (NSInteger)month
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.month;
}

- (NSInteger)week
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.weekOfYear;
}

- (NSInteger)weekday
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.weekday;
}

- (NSInteger)nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger)day
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.day;
}

- (NSInteger)hour
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.hour;
}

- (NSInteger)nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate* newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents* components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
	return components.hour;
}

- (NSInteger)minute
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.minute;
}

- (NSInteger)seconds
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.second;
}

- (NSInteger)nanoseconds
{
	NSDateComponents* components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.nanosecond;
}

#pragma mark - String Properties

/*!
 * @brief Format Description. http://nsdateformatter.com/
 * @discussion
 +------------------------------------------------------------------------------------------------------------------------------------+
 |        Charact  	  Example     Description                                                                                         |
 | Year   +---------------------------------------------------------------------------------------------------------------------------+
 |        y           2008        Year, no padding                                                                                    |
 |        yy          08          Year, two digits (padding with a zero if necessary)                                                 |
 |        yyyy        2008        Year, minimum of four digits (padding with zeros if necessary)                                      |
 | Quart  +---------------------------------------------------------------------------------------------------------------------------+
 |        Q           4           The quarter of the year. Use QQ if you want zero padding.                                           |
 |        QQQ         Q4          Quarter including "Q"                                                                               |
 |        QQQQ        4th         quarter Quarter spelled out                                                                         |
 | Month  +---------------------------------------------------------------------------------------------------------------------------+
 |        M           12          The numeric month of the year. A single M will use '1' for January.                                 |
 |        MM          12          The numeric month of the year. A double M will use '01' for January.                                |
 |        MMM         Dec         The shorthand name of the month                                                                     |
 |        MMMM        December	  Full name of the month                                                                              |
 |        MMMMM       D           Narrow name of the month                                                                            |
 | Day    +---------------------------------------------------------------------------------------------------------------------------+
 |        d           14          The day of the month. A single d will use 1 for January 1st.                                        |
 |        dd          14          The day of the month. A double d will use 01 for January 1st.                                       |
 |        F           3rd         Tuesday in December The day of week in the month                                                    |
 |        E           Tues        The day of week in the month                                                                        |
 |        EEEE        Tuesday     The full name of the day                                                                            |
 |        EEEEE       T           The narrow day of week                                                                              |
 | Hour   +---------------------------------------------------------------------------------------------------------------------------+
 |        h           4           The 12|hour hour.                                                                                   |
 |        hh          04          The 12|hour hour padding with a zero if there is only 1 digit                                       |
 |        H           16          The 24|hour hour.                                                                                   |
 |        HH          16          The 24-hour hour padding with a zero if there is only 1 digit.                                      |
 |        a           PM          AM / PM for 12-hour time formats                                                                    |
 | Minute +---------------------------------------------------------------------------------------------------------------------------+
 |        m           35          The minute, with no padding for zeroes.                                                             |
 |        mm          35          The minute with zero padding.                                                                       |
 | Second +---------------------------------------------------------------------------------------------------------------------------+
 |        s           8           The seconds, with no padding for zeroes.                                                            |
 |        ss          08          The seconds with zero padding.                                                                      |
 | Tz     +---------------------------------------------------------------------------------------------------------------------------+
 |        zzz         CST         The 3 letter name of the time zone. Falls back to GMT-08:00 (hour offset) if the name is not known. |
 |        zzzz        Central Standard Time	The expanded time zone name, falls back to GMT-08:00 (hour offset) if name is not known.  |
 |        zzzz        CST-06:00	  Timezone with abreviation and offset                                                                |
 |        Z           -0600       RFC 822 GMT format. Can also match a literal Z for Zulu (UTC) time.                                 |
 |        ZZZZZ       |06:00      ISO 8601 time zone format                                                                           |
 +------------------------------------------------------------------------------------------------------------------------------------+
 */

- (NSString*)stringWithFormat:(NSString*)format
{
	NSDateFormatter* formatter = [NSDateFormatter formatterWithDateFormat:format];
	formatter.dateFormat = format;
	return [formatter stringFromDate:self];
}

- (NSString*)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
	NSDateFormatter* formatter = [NSDateFormatter new];
	formatter.dateStyle = dateStyle;
	formatter.timeStyle = timeStyle;
	return [formatter stringFromDate:self];
}

- (NSString*)shortDateTimeString
{
	return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString*)shortTimeString
{
	return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString*)shortDateString
{
	return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString*)mediumDateTimeString
{
	return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSString*)mediumTimeString
{
	return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSString*)mediumDateString
{
	return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString*)longDateTimeString
{
	return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
}

- (NSString*)longTimeString
{
	return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
}

- (NSString*)longDateString
{
	return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString*)longDateShortTimeString
{
	return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString*)customLongWeekdayMonthDayYearString
{
	NSString* formatString;

	if ([self isThisYear]) {
		// Monday, August 14
		formatString = @"EEEE, MMMM d";
	} else {
		// Monday, August 14, 2017
		formatString = @"EEEE, MMMM d, YYYY";
	}
	return [self stringWithFormat:formatString];
}

- (NSString*)customShortMonthAndDayString
{
	// 08-14
	return [self stringWithFormat:@"MM-dd"];
}

- (NSString*)customShortMonthAndYearString
{
	// 08 2017
	return [self stringWithFormat:@"LL YYYY"];
}

- (NSString*)customLongMonthAndYearString
{
	// August 2017
	return [self stringWithFormat:@"LLLL YYYY"];
}

- (NSString*)customShortWeekdayAndDayString
{
	// Mon 14
	return [self stringWithFormat:@"EE dd"];
}

- (NSString*)customLongWeekdayAndDayString
{
	// Monday 14
	return [self stringWithFormat:@"EEEE dd"];
}

- (NSString*)customLongMonthDayYearString
{
	// August 14, 2017
	return [self stringWithFormat:@"MMMM d, yyyy"];
}

- (NSString*)customLongWeekdayString
{
	// Monday
	return [self stringWithFormat:@"EEEE"];
}

#pragma mark - Comparing Dates

- (NSDate*)convertToUTCDate
{
	//UTC time

	if (_utcDateFormatter == nil) {
		_utcDateFormatter = [[NSDateFormatter alloc] init];
		[_utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	}

	NSDate* d = [_utcDateFormatter defaultDate];

	NSAssert(d != nil, @"Could not convert date to utc date format");

	return d;
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate*)aDate
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
	return ((components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day));
}

- (BOOL)isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate tomorrow]];
}

- (BOOL)isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate yesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate*)aDate
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];

	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.weekOfYear != components2.weekOfYear)
		return NO;

	// Must have a time interval under 1 week.
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate* newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate* newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate:(NSDate*)aDate
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
	return ((components1.month == components2.month) && (components1.year == components2.year));
}

- (BOOL)isSameDayAsDate:(NSDate*)aDate
{
	return [[NSDate currentCalendar] isDate:aDate inSameDayAsDate:self];
}

- (BOOL)isThisMonth
{
	return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isLastMonth
{
	return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL)isNextMonth
{
	return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL)isSameYearAsDate:(NSDate*)aDate
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL)isThisYear
{
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate now]];

	return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear
{
	NSDateComponents* components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents* components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate now]];

	return (components1.year == (components2.year - 1));
}

- (BOOL)isInFuture
{
	return ([self isLaterThanDate:[NSDate now]]);
}

- (BOOL)isInPast
{
	return ([self isEarlierThanDate:[NSDate now]]);
}

#pragma mark - Date Roles

- (BOOL)isTypicallyWeekend
{
	NSDateComponents* components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
	return ((components.weekday == 1) || (components.weekday == 7));
}

- (BOOL)isTypicallyWorkday
{
	return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

- (NSDate*)dateByAddingYears:(NSInteger)years
{
	return [self dateByAddingYears:years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateByAddingMonths:(NSInteger)months
{
	return [self dateByAddingYears:0 months:months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateByAddingWeeks:(NSInteger)weeks
{
	return [self dateByAddingYears:0 months:0 weeks:weeks days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateByAddingDays:(NSInteger)days
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:days hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateByAddingHours:(NSInteger)hours
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:hours minutes:0 seconds:0];
}

- (NSDate*)dateByAddingMinutes:(NSInteger)minutes
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0];
}

- (NSDate*)dateByAddingSeconds:(NSInteger)seconds
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:seconds];
}

- (NSDate*)dateBySubtractingYears:(NSInteger)years
{
	return [self dateByAddingYears:-years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateBySubtractingMonths:(NSInteger)months
{
	return [self dateByAddingYears:0 months:-months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateBySubtractingWeeks:(NSInteger)weeks
{
	return [self dateByAddingYears:0 months:0 weeks:-weeks days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateBySubtractingDays:(NSInteger)days
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:-days hours:0 minutes:0 seconds:0];
}

- (NSDate*)dateBySubtractingHours:(NSInteger)hours
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:-hours minutes:0 seconds:0];
}

- (NSDate*)dateBySubtractingMinutes:(NSInteger)minutes
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-minutes seconds:0];
}

- (NSDate*)dateBySubtractingSeconds:(NSInteger)seconds
{
	return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-seconds];
}

- (NSDate*)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
	NSDateComponents* comps = [NSDateComponents new];
	if (years)
		[comps setYear:years];
	if (months)
		[comps setMonth:months];
	if (weeks)
		[comps setWeekOfYear:weeks];
	if (days)
		[comps setDay:days];
	if (hours)
		[comps setHour:hours];
	if (minutes)
		[comps setMinute:minutes];
	if (seconds)
		[comps setSecond:seconds];
	return [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate*)dateBySettingHour:(NSInteger)h minute:(NSInteger)m second:(NSInteger)s
{
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDate* retDate = [calendar dateBySettingHour:h minute:m second:s ofDate:self options:0];

	return retDate;
}

- (NSDate*)dateByRoundingUp
{
	NSDateComponents* time = [[NSCalendar currentCalendar]
		components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear
		  fromDate:self];
	NSInteger minutes = [time minute];
	float minuteUnit = ceil((float)minutes / 5.0);
	minutes = minuteUnit * 5.0;
	[time setMinute:minutes];
	return [[NSCalendar currentCalendar] dateFromComponents:time];
}

- (NSDate*)nextDay
{
	return [self dateByAddingDays:1];
}

- (NSDate*)previousDay
{
	return [self dateByAddingDays:-1];
}

- (NSDate*)nextWeek
{
	return [self dateByAddingWeeks:1];
}

- (NSDate*)previousWeek
{
	return [self dateByAddingWeeks:-1];
}

- (NSDate*)nextMonth
{
	return [self dateByAddingMonths:1];
}

- (NSDate*)previousMonth
{
	return [self dateByAddingMonths:-1];
}

- (NSDate*)startOfDay
{
	return [[NSDate currentCalendar] startOfDayForDate:self];
}

- (NSDate*)endOfDay
{
	return [[[self startOfDay] nextDay] dateByAddingSeconds:-1];
}

- (NSDate*)midnight
{
	return [[self endOfDay] dateByAddingSeconds:1];
}

- (NSDate*)firstDayOfWeek
{
	return [self dateWithDay:[NSDate weekStartsWithDay] direction:NSOrderedDescending includeCurrent:YES];
}

- (NSDate*)lastDayOfWeek
{
	return [self dateWithDay:[NSDate weekEndsWithDay] direction:NSOrderedAscending includeCurrent:YES];
}

- (NSDate*)startOfWeek
{
	return [[self firstDayOfWeek] startOfDay];
}

- (NSDate*)endOfWeek
{
	return [[self lastDayOfWeek] endOfDay];
}

- (NSDate*)startOfMonth
{
	return [[self firstDayOfMonth] startOfDay];
}

- (NSDate*)endOfMonth
{
	return [[self lastDayOfMonth] endOfDay];
}

- (NSDate*)firstDayOfMonth
{
	NSDateComponents* comp = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
	[comp setDay:1];
	return [[NSDate currentCalendar] dateFromComponents:comp];
}

- (NSDate*)lastDayOfMonth
{
	// http://stackoverflow.com/questions/2772348/nsdate-getting-the-last-day-of-a-month/2772490#2772490

	NSDateComponents* comps = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];

	// set last of month
	[comps setMonth:[comps month] + 1];
	[comps setDay:0];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

- (NSDate*)startOfWeekend
{
	return [[self dateWithDay:7 direction:NSOrderedAscending includeCurrent:YES] startOfDay];
}

- (NSDate*)endOfWeekend
{
	return [[self dateWithDay:1 direction:NSOrderedAscending includeCurrent:YES] endOfDay];
}

- (NSDateComponents*)componentsWithOffsetFromDate:(NSDate*)aDate
{
	NSDateComponents* dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark - Extremes

- (NSDate*)dateAtStartOfWeek
{
	return [self dateBySubtractingDays:((([self weekday] - [[self class] weekStartsWithDay]) + 7) % 7)];
}

- (NSDate*)dateAtStartOfMonth
{
	NSDateComponents* components = [[NSDate currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
															   fromDate:self];
	components.day = 1;
	NSDate* firstDayOfMonthDate = [[NSDate currentCalendar] dateFromComponents:components];
	return firstDayOfMonthDate;
}

- (NSDate*)dateAtNearest5Minute
{
	NSDateComponents* timeComponents = [NSDate.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
																 fromDate:self];

	NSInteger minutes = [timeComponents minute];

	float minuteUnit = ceil((float)minutes / 5.0);

	minutes = minuteUnit * 5.0;

	[timeComponents setMinute:minutes];

	return [NSDate.currentCalendar dateFromComponents:timeComponents];
}

- (NSDate*)dateWithCurrentTime
{
	NSCalendar* calendar = [self.class currentCalendar];
	NSDate* today = [NSDate date];

	NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

	NSDateComponents* todayComps = [calendar components:units fromDate:today];

	NSDateComponents* comps = [calendar components:units fromDate:self];
	comps.hour = todayComps.hour;
	comps.minute = todayComps.minute;
	comps.second = todayComps.second;

	return [calendar dateFromComponents:comps];
}

- (NSDate*)dateWithDay:(NSUInteger)day direction:(NSComparisonResult)direction includeCurrent:(BOOL)includeCurrent
{
	NSDate* date = self;
	if (!includeCurrent) {
		date = direction == NSOrderedAscending ? [date nextDay] : [date previousDay];
	}

	while ([date weekday] != day) {
		date = direction == NSOrderedAscending ? [date nextDay] : [date previousDay];
	}

	return date;
}

#pragma mark - Retrieving Intervals

- (NSInteger)secondsAfterDate:(NSDate*)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_SECOND);
}

- (NSInteger)secondsBeforeDate:(NSDate*)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_SECOND);
}

- (NSInteger)minutesAfterDate:(NSDate*)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate*)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate*)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate*)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate*)aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger)(ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate*)aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger)(ti / D_DAY);
}

- (NSInteger)distanceInDaysToDate:(NSDate*)anotherDate
{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
	return components.day;
}

#pragma mark - Date Comparisons

- (BOOL)isEarlierThanDate:(NSDate*)aDate
{
	return ([self earlierDate:aDate] == self && ![self isEqualToDate:aDate]);
}

- (BOOL)isLaterThanDate:(NSDate*)aDate
{
	return ([self laterDate:aDate] == self && ![self isEqualToDate:aDate]);
}

- (BOOL)isEarlierOrEqualToDate:(NSDate*)aDate
{
	return ([self earlierDate:aDate] == self);
}

- (BOOL)isLaterOrEqualToDate:(NSDate*)aDate
{
	return ([self laterDate:aDate] == self);
}

- (BOOL)isBetweenDate:(NSDate*)startDate andDate:(NSDate*)endDate
{
	if (([self compare:startDate] != NSOrderedAscending) && ([self compare:endDate] != NSOrderedDescending))
		return YES;
	else
		return NO;
}

@end

@implementation NSDateFormatter (Utilities)

+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat
{
	return [self formatterWithDateFormat:dateFormat locale:[NSLocale currentLocale]];
}

+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat locale:(NSLocale*)locale
{
	return [self formatterWithDateFormat:dateFormat locale:[NSLocale currentLocale] timeZone:[NSTimeZone localTimeZone]];
}

+ (NSDateFormatter*)formatterWithDateFormat:(NSString*)dateFormat locale:(NSLocale*)locale timeZone:(NSTimeZone*)timeZone
{
	NSDateFormatter* df = [NSDateFormatter new];
	df.dateFormat = dateFormat;
	df.locale = locale;
	df.timeZone = timeZone;
	return df;
}

@end
