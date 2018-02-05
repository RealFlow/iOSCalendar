//
//  DGCalendarCompactWeekReusableView.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekReusableView.h"

@implementation DGCalendarCompactWeekReusableView

#pragma mark - Class Methods

+ (NSString*)reuseIdentifier
{
	return NSStringFromClass(self);
}

@end
