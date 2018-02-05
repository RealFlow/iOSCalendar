//
//  DGCalendarEvent.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGCalendarEvent : NSObject

/**
 The start time for the event.
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 The end time for the event.
 */
@property (nonatomic, strong) NSDate *endDate;

/**
 The event title.
 */
@property (nonatomic, strong) NSString * title;

/**
 The event description.
 */

@property (nonatomic, strong) NSString * desc;

/**
 Defines the event color.
 */
@property (nonatomic, strong) UIColor * eventColor;


- (NSString *)eventFromToDescription;

@end

NS_ASSUME_NONNULL_END
