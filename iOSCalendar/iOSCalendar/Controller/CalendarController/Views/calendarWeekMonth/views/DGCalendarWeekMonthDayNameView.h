//
//  DGCalendarWeekMonthDayNameView.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekReusableView.h"

@interface DGCalendarWeekMonthDayNameView : DGCalendarCompactWeekReusableView

@property UIColor* weekHeaderColor;

- (void)updateWithWeekDayIndex:(NSInteger)weekDayIndex;

@end
