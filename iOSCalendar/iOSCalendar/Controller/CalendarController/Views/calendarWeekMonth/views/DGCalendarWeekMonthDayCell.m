//
//  DGCalendarWeekMonthDayCell.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarWeekMonthDayCell.h"

static const CGFloat kPreferredFontSize = 17;
static const CGFloat kSelectionBackgroundSize = 20;
static const CGFloat kSelectionBackgroundMargin = -5;
static const CGFloat kEventSize = 4;
static const CGFloat kEventsMargin = 2;
static const CGFloat kMaxEventViewsDisplayed = 3;

@interface DGCalendarWeekMonthDayCell ()

@property (strong, nonatomic) UILabel* label;
@property (strong, nonatomic) UIView* selectionBg;
@property (strong, nonatomic) UIStackView* eventStack;

@end

@implementation DGCalendarWeekMonthDayCell

#pragma mark - Class Methods

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initUserInterface];
	}
	return self;
}

+ (NSString*)reuseIdentifier
{
	return NSStringFromClass(self);
}

#pragma mark - View Lifecycle Methods

- (void)awakeFromNib
{
	[super awakeFromNib];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
}

- (void)initUserInterface
{
    _dayTextColorToday = _dayTextColorToday ? : [UIColor redColor];
    _dayTextColorThisMonth = _dayTextColorThisMonth ? : [UIColor colorWithRed:55/255.f green:55/255.f blue:55/255.f alpha:1];
    _dayTextColorOtherMonth = _dayTextColorOtherMonth ? : [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
    _dayTextColorSelected = _dayTextColorSelected ? : [UIColor whiteColor];
    _dayViewBackgroundColor = _dayViewBackgroundColor ? : [UIColor whiteColor];
    _dayViewBackgroundColorToday = _dayViewBackgroundColorToday ? : [UIColor redColor];
    _dayViewBackgroundColorSelected = _dayViewBackgroundColorSelected ? : [UIColor colorWithRed:22/255.f green:105/255.f blue:159/255.f alpha:1];
    
	_selectionBg = [[UIView alloc] initWithFrame:CGRectZero];
	[_selectionBg.widthAnchor constraintEqualToConstant:kSelectionBackgroundSize].active = true;
	[_selectionBg.heightAnchor constraintEqualToConstant:kSelectionBackgroundSize].active = true;
	_selectionBg.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_selectionBg];
	[_selectionBg.layer setCornerRadius:kSelectionBackgroundSize / 2];
	[_selectionBg.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
	[_selectionBg.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:kSelectionBackgroundMargin].active = true;

	_label = [[UILabel alloc] initWithFrame:self.frame];
	_label.font = [UIFont fontWithName:@"Helvetica" size:kPreferredFontSize];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	[self insertSubview:_label aboveSubview:_selectionBg];
	_label.text = @"00";
	[_label sizeToFit];
	[_label.centerXAnchor constraintEqualToAnchor:_selectionBg.centerXAnchor].active = true;
	[_label.centerYAnchor constraintEqualToAnchor:_selectionBg.centerYAnchor].active = true;
}

#pragma mark - Update Methods

- (void)updateWithDate:(NSDate*)date
{
	self.date = date;
}

- (void)updateWithMonthDayEvents:(NSArray<DGCalendarWeekMonthDayCellEventHelper*>*)events showRealColor:(BOOL)showRealColor
{
	if (events.count > 0) {
		//add events stack view
		if (!self.eventStack) {
			self.eventStack = [[UIStackView alloc] init];
			self.eventStack.axis = UILayoutConstraintAxisHorizontal;
			self.eventStack.spacing = kEventSize / 2;
			self.eventStack.alignment = UIStackViewAlignmentCenter;
			self.eventStack.distribution = UIStackViewDistributionEqualSpacing;
			self.eventStack.translatesAutoresizingMaskIntoConstraints = NO;

			[self addSubview:self.eventStack];
			//Layout for Stack View
			[self.eventStack.centerXAnchor constraintEqualToAnchor:_selectionBg.centerXAnchor].active = true;
			[self.eventStack.topAnchor constraintEqualToAnchor:_selectionBg.bottomAnchor constant:kEventsMargin].active = true;
		}

		for (NSInteger i = 0; i < MIN(events.count, kMaxEventViewsDisplayed); i++) {
			UIView* eventView = [[UIView alloc] init];
			[eventView.heightAnchor constraintEqualToConstant:kEventSize].active = true;
			[eventView.widthAnchor constraintEqualToConstant:kEventSize].active = true;
			[eventView.layer setCornerRadius:kEventSize / 2];
			[eventView setBackgroundColor:showRealColor ? events[i].color : self.dayTextColorOtherMonth];
			[self.eventStack addArrangedSubview:eventView];
		}
	}
}

- (void)updateWithOptions:(DGCalendarWeekMonthDayCellStyleOptions)options
{
	UIColor* originTextColor = self.dayTextColorThisMonth;
	UIFont* originFont = [UIFont fontWithName:@"Helvetica" size:kPreferredFontSize];
	[self.selectionBg setHidden:YES];

	if ((options & DGCalendarWeekMonthDayCellStyleSelected) && (options & DGCalendarWeekMonthDayCellStyleToday)) {
		originFont = [UIFont fontWithName:@"Helvetica" size:kPreferredFontSize - 4];
		originTextColor = self.dayTextColorSelected;
		[self.selectionBg setHidden:NO];
		[self.selectionBg setBackgroundColor:self.dayViewBackgroundColorToday];

	} else if (options & DGCalendarWeekMonthDayCellStyleToday) {
		originTextColor = self.dayViewBackgroundColorToday;

	} else if (options & DGCalendarWeekMonthDayCellStyleSelected) {
		originFont = [UIFont fontWithName:@"Helvetica" size:kPreferredFontSize - 4];
		originTextColor = self.dayTextColorSelected;
		[self.selectionBg setHidden:NO];
		[self.selectionBg setBackgroundColor:self.dayViewBackgroundColorSelected];
	}

	UIColor* textColor = originTextColor;
	UIFont* font = originFont;

	if (options & DGCalendarWeekMonthDayCellStyleNormal) {
		textColor = originTextColor;
		font = originFont;
	}

	if (options & DGCalendarWeekMonthDayCellStyleOtherMonth) {
		textColor = self.dayTextColorOtherMonth;
		font = [originFont fontWithSize:kPreferredFontSize - 1];
	}

	[self.label setText:@(self.date.day).stringValue];
	[self.label setTextColor:textColor];
	[self.label setFont:font];
	[self.label sizeToFit];
}

- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
{
	return layoutAttributes;
}

- (void)prepareForReuse
{
	[super prepareForReuse];

	//cleaning events stack view
	[self.eventStack.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
		[self.eventStack removeArrangedSubview:obj];
		[obj removeFromSuperview];
	}];
}

@end

@implementation DGCalendarWeekMonthDayCellEventHelper

@end
