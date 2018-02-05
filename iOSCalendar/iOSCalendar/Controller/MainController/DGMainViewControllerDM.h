//
//  DGMainViewControllerDM.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGCalendarEvent.h"

@interface DGMainViewControllerDM : NSObject

@property (nonatomic, strong) NSDate* currentDate;

/**
 *  All events
 */
@property (nonatomic, strong) NSMutableArray<DGCalendarEvent*>* events;

/**
 *  Array of holidays
 */
@property (nonatomic, strong) NSMutableArray<DGCalendarEvent*>* passiveDays;

@end
