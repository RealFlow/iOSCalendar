//
//  DGEventsController.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCalendarEvent.h"

@class DGEventsController;

@interface DGEventsController : UITableViewController

- (void)updateWithEvents:(NSArray<DGCalendarEvent*>*)events;

@end
