//
//  DGMainViewControllerDM.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGMainViewControllerDM.h"

@implementation DGMainViewControllerDM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentDate = [NSDate now];
        _events = @[].mutableCopy;
        _passiveDays = @[].mutableCopy;
        
        [self initializeFakeData];
    }
    
    return self;
}

- (void)initializeFakeData
{
    NSArray<NSString *> *eventTitles = @[@"Do Laundry", @"Meeting with Paul", @"Call Iria", @"Pick up new car", @"Beer with friends", @"Deliver Project Statistics", @"Follow up meeting", @"Bring Cake to Kate", @"Wish happy bday",@"Go to Supermarket"];
    
    NSArray<NSString *> *eventDescriptions = @[@"Take that into account", @"It will be really great", @"Must consider also other options", @"Consult this with your wife", @"TODO: change this plan"];
    
    NSArray<UIColor *> *eventColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor cyanColor]];
    
    NSDate *threeMonthsBefore = [[self.currentDate firstDayOfMonth] dateBySubtractingMonths:3];
    NSDate *threeMonthsAfter = [[self.currentDate firstDayOfMonth] dateByAddingMonths:3];
    
    while ([threeMonthsBefore isEarlierThanDate:threeMonthsAfter]) {
        
        NSInteger eventPerDay = [self randomNumberBetween:0 maxNumber:3];
        
        for (NSUInteger i = 0 ; i < eventPerDay; i++) {
            
            NSInteger titleIndex = [self randomNumberBetween:0 maxNumber:eventTitles.count - 1];
            NSInteger descIndex = [self randomNumberBetween:0 maxNumber:eventDescriptions.count - 1];
            NSInteger colorIndex = [self randomNumberBetween:0 maxNumber:eventColors.count - 1];
            
            DGCalendarEvent *event = [[DGCalendarEvent alloc] init];
            
            event.title = [eventTitles objectAtIndex:titleIndex];
            event.desc = [eventDescriptions objectAtIndex:descIndex];
            event.eventColor = [eventColors objectAtIndex:colorIndex];
            event.startDate = threeMonthsBefore;
            event.endDate = [threeMonthsBefore dateByAddingHours:2];
            
            [self.events addObject:event];
        }
        
        threeMonthsBefore = [threeMonthsBefore dateByAddingDays:1];
    }
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}

@end
