//
//  DGCalendarWeekMonthDayNameView.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarWeekMonthDayNameView.h"

@interface DGCalendarWeekMonthDayNameView ()

@property NSDateFormatter* formater;
@property (strong, nonatomic) UILabel* label;

@end

@implementation DGCalendarWeekMonthDayNameView

#pragma mark - View Lifecycle Methods

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeFormatter];
		[self initUserInterface];
	}
	return self;
}

#pragma mark - Initialization Methods

- (void)initUserInterface
{
	_label = [[UILabel alloc] init];
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	_label.textAlignment = NSTextAlignmentCenter;
	_label.font = [UIFont fontWithName:@"OpenSans" size:14];
	_label.text = @"MO";
	[self addSubview:_label];
	[_label.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
	[_label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
	[_label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
	[_label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)initializeFormatter
{
	self.formater = [NSDateFormatter new];
	[self.formater setCalendar:[NSDate currentCalendar]];
	[self.formater setLocale:[NSLocale currentLocale]];
	[self.formater setTimeZone:[NSTimeZone localTimeZone]];
}

#pragma mark - Update Methods

- (void)updateWithWeekDayIndex:(NSInteger)weekDayIndex
{
	NSMutableArray<NSString*>* names = self.formater.shortWeekdaySymbols.mutableCopy;
	if (NSDate.currentCalendar.firstWeekday > 1) {
		NSString* sunday = names.firstObject;
		[names removeObject:sunday];
		[names addObject:sunday];
	}

	[self.label setText:[names[weekDayIndex].uppercaseString substringToIndex:2]];
	[self.label setTextColor:self.weekHeaderColor];
}

- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
{
	return layoutAttributes;
}

@end
