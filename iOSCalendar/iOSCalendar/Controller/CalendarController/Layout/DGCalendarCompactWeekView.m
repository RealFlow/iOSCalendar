//
//  DGCalendarCompactWeekView.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGCalendarCompactWeekView.h"

@implementation DGCalendarCompactWeekView

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	[self setup];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	[self setup];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout*)layout
{
	self = [super initWithFrame:frame collectionViewLayout:layout];
	[self setup];
	return self;
}

- (instancetype)init
{
	self = [super init];
	[self setup];
	return self;
}

- (void)setup
{
    self.collectionBackgroundColor = self.collectionBackgroundColor ?: [UIColor whiteColor];
    [self setBackgroundColor:self.collectionBackgroundColor];
	[self setDecelerationRate:UIScrollViewDecelerationRateFast];
	[self setPagingEnabled:YES];
}

@end
