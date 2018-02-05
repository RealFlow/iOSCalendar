//
//  DGEventCell.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCalendarEvent.h"

@interface DGEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventSubtitleLabel;

- (void)updateWithEvent:(DGCalendarEvent *)event;

@end
