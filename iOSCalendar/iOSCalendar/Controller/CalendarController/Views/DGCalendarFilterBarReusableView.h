//
//  DGCalendarFilterBarReusableView.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@class DGCalendarFilterBarReusableView;

@protocol DGCalendarFilterBarReusableViewDelegate <NSObject>
@required
- (void)didTapLabelsInFilterBar:(DGCalendarFilterBarReusableView*)bar;

@end

@interface DGCalendarFilterBarReusableView : DGCalendarCompactWeekReusableView <UISearchBarDelegate>

@property (weak, nonatomic, nullable) id<DGCalendarFilterBarReusableViewDelegate> delegate;
@property UIColor* dayTextColorHeader UI_APPEARANCE_SELECTOR;

- (void)updateWithDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
