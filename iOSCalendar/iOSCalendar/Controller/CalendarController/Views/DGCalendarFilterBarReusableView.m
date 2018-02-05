//
//  DGCalendarFilterBarReusableView.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarFilterBarReusableView.h"

static const CGFloat kLabelLeadingMargin = 20;

@interface DGCalendarFilterBarReusableView ()

@property UITapGestureRecognizer* labelsTapRecognizer;
@property (strong, nonatomic) UILabel* dateLabel;

@end

@implementation DGCalendarFilterBarReusableView

#pragma mark - View Lifecycle Methods

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initUserInterface];
		[self initializeTapRecognizers];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)dealloc
{
	[self.dateLabel removeGestureRecognizer:self.labelsTapRecognizer];
}

#pragma mark - Initialization Methods

- (void)initUserInterface
{
    _dayTextColorHeader = _dayTextColorHeader ? : [UIColor colorWithRed:22/255.f green:105/255.f blue:159/255.f alpha:1];
    
	_dateLabel = [[UILabel alloc] init];
	_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_dateLabel setUserInteractionEnabled:YES];
	[self addSubview:_dateLabel];
	[_dateLabel.heightAnchor constraintLessThanOrEqualToAnchor:self.heightAnchor].active = YES;
	[_dateLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
	[_dateLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:kLabelLeadingMargin].active = YES;
	[_dateLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:kLabelLeadingMargin].active = YES;
}

- (void)initializeTapRecognizers
{
	[self setLabelsTapRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(didTapLabels)]];
	[_dateLabel addGestureRecognizer:self.labelsTapRecognizer];
}

#pragma mark - Update Methods

- (void)updateWithDate:(NSDate*)date
{
	static NSDateFormatter* yearFormater;
	static NSDateFormatter* monthFormater;
	static NSDateFormatter* weekDayFormater;

	static dispatch_once_t formatersToken;
	dispatch_once(&formatersToken, ^{
		yearFormater = [NSDateFormatter new];
		monthFormater = [NSDateFormatter new];
		weekDayFormater = [NSDateFormatter new];

		[yearFormater setDateFormat:@"YYYY"];
		[monthFormater setDateFormat:@"MMMM d"];
		[weekDayFormater setDateFormat:@"EEEE"];
	});

	NSMutableString* dateString = @"".mutableCopy;

	[dateString appendFormat:@"%@, ", [weekDayFormater stringFromDate:date].uppercaseString];
	[dateString appendString:[monthFormater stringFromDate:date]];

	if (![date isSameYearAsDate:[NSDate date]]) {
		[dateString appendFormat:@" %@", [yearFormater stringFromDate:date]];
	}

	[self.dateLabel setTextColor:self.dayTextColorHeader];
	[self.dateLabel setText:dateString];
	[self.dateLabel sizeToFit];
}

#pragma mark - Helper Methods

- (void)didTapLabels
{
	if (self.delegate)
		[self.delegate didTapLabelsInFilterBar:self];
}

@end
