//
//  DGCalendarEvent.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarEvent.h"

@implementation DGCalendarEvent

- (NSString *)eventFromToDescription
{
	return [NSString stringWithFormat:@"%@. from %@ to %@", self.desc, [self.startDate shortTimeString], [self.endDate shortTimeString]];
}

@end
