//
//  DGMainViewController.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGMainViewController.h"
#import "DGCalendarRequestManager.h"
#import "DGCalendarController.h"
#import "DGCalendarWeekMonthViewLayout.h"
#import "DGEventsController.h"

#define kCalendarDefaultAnimationDuration 0.3
#define kCalendarDefaultToolbarButtonWidth 26
#define kCalendarDefaultToolbarButtonFontSize 12

@interface DGMainViewController () <DGCalendarRequestDelegate, DGCalendarControllerDelegate>

/**
 *  Containers on the screen, they contain header, calendar and eventsTable views
 */
@property (nonatomic, strong) UIView* calendarContainerView;
@property (nonatomic, strong) UIView* tableContainerView;

/**
 *  Toolbar buttons
 */
@property UIBarButtonItem* todayBarButton;
@property UIBarButtonItem* switchBarButton;

/**
 *  Calendar
 */
@property (nonatomic, strong) DGCalendarRequestManager* calendarRequestManager;
@property (nonatomic, strong) DGCalendarController* calendarController;
@property (nonatomic, weak) UIView* calendarView;

#define kViewMode @"viewMode"
@property (nonatomic) DGCalendarMode viewMode;

/**
 *  Selected Day Event List
 */
@property (nonatomic, strong) DGEventsController* eventsController;
@property (nonatomic, weak) UIView* eventsControllerView;
@property (nonatomic, weak) NSArray* eventsForDate;

/**
 *  Reference to last selected/focused day in calendar
 */
#define kLastSelectedDate @"lastSelectedDate"
@property (nonatomic) NSDate* lastSelectedDate;

/**
 *  variable constraints:
 *  calendar height depends on its mode (month or week)
 *	table bottom distance with its superview depends on whether there is toolbar with actions or not
 */
@property (nonatomic, weak) NSLayoutConstraint* calendarHeightConstraint;
@property (nonatomic, weak) NSLayoutConstraint* tableBottomVerticalDistanceConstraint;

@property (nonatomic) BOOL requiresRefresh;

@end

@implementation DGMainViewController

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self initializePreProcessing];
	[self initializeToolbar];
	[self initializeContainers];
	[self initializeCalendar];
	[self initializeEvents];
	[self initializeObservers];
    [self initializeCalendarRequestManager];
    
    [self update];
}

- (void)viewWillAppear:(BOOL)animated
{
	if (self.lastSelectedDate)
		[self.calendarController updateWithSelectedDate:self.lastSelectedDate];

	[super viewWillAppear:animated];
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);

	@try {
		[self removeObserver:self forKeyPath:kViewMode];
	} @catch (NSException* exception) {
	}

	@
	try {
		[self removeObserver:self forKeyPath:kLastSelectedDate];
	} @catch (NSException* exception) {
	}

	@
	try {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:kDGGlobalMidnightUpdate object:nil];
	} @catch (NSException* exception) {
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    DGWeakify(self);
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        DGStrongify(self);
        [self.calendarController updateWithSelectedDate:self.lastSelectedDate];
    }];
}


#pragma mark - Initialization Methods

- (void)initializePreProcessing
{
    self.requiresRefresh = YES;
    self.dataModel = [[DGMainViewControllerDM alloc] init];
    self.viewMode = kDGCalendarModeWeek;
    self.toolbarButtonTintColor = _toolbarButtonTintColor ?: [UIColor colorWithRed:22/255.f green:105/255.f blue:159/255.f alpha:1];
    self.controllerBackgroundColor = _controllerBackgroundColor ?: [UIColor whiteColor];
}

- (void)initializeToolbar
{
	UIImage* todayImage = [UIImage imageNamed:@"calendar_today_default"];
	NSString* dateText = [NSString stringWithFormat:@"%ld", (long)[[NSDate now] day]];

	CGFloat width = [dateText sizeWithAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:kCalendarDefaultToolbarButtonFontSize] }].width;
	todayImage = [self drawText:dateText inImage:todayImage atPoint:CGPointMake(round((kCalendarDefaultToolbarButtonWidth - width) / 2.f), 6)];

	self.todayBarButton = [[UIBarButtonItem alloc] initWithImage:todayImage style:UIBarButtonItemStyleDone target:self action:@selector(todayCalendarMode)];
	self.switchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_switch_default"] style:UIBarButtonItemStyleDone target:self action:@selector(switchCalendarMode)];

	[self.todayBarButton setWidth:kCalendarDefaultToolbarButtonWidth];
	[self.switchBarButton setWidth:kCalendarDefaultToolbarButtonWidth];

	[self.navigationItem setRightBarButtonItems:@[ self.switchBarButton, self.todayBarButton ] animated:self.navigationItem.rightBarButtonItem != nil];
}

- (void)initializeContainers
{
	self.calendarContainerView = [[UIView alloc] initWithFrame:CGRectZero];
	self.tableContainerView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.calendarContainerView setAlpha:0.f];
	[self.tableContainerView setAlpha:0.f];

	[self.view addSubview:self.calendarContainerView];
	[self.view addSubview:self.tableContainerView];

	self.calendarContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	self.tableContainerView.translatesAutoresizingMaskIntoConstraints = NO;

	NSDictionary* containers = @{ @"calendarContainerView" : self.calendarContainerView, @"tableContainerView" : self.tableContainerView };

	// Horizontal constraints
	NSArray* calendarHorizontalConstraintArray = [NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-0-[calendarContainerView]-0-|"
							options:0
							metrics:nil
							  views:containers];
	NSArray* tableHorizontalConstraintArray = [NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-0-[tableContainerView]-0-|"
							options:0
							metrics:nil
							  views:containers];
	// Constraints among views
	NSArray* headerCalendarVerticalDistanceConstraintArray = [NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-70-[calendarContainerView]"
							options:0
							metrics:nil
							  views:containers];
	NSArray* calendarTableVerticalDistanceConstraintArray = [NSLayoutConstraint
		constraintsWithVisualFormat:@"V:[calendarContainerView]-0-[tableContainerView]"
							options:0
							metrics:nil
							  views:containers];

	[self.view addConstraints:calendarHorizontalConstraintArray];
	[self.view addConstraints:tableHorizontalConstraintArray];
	[self.view addConstraints:headerCalendarVerticalDistanceConstraintArray];
	[self.view addConstraints:calendarTableVerticalDistanceConstraintArray];

	// Variable constraints: headerHeight, calendarHeight, tableBottomVerticalDistance
	
	self.calendarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.calendarContainerView
																 attribute:NSLayoutAttributeHeight
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1.0
																  constant:[DGCalendarController heightForMode:kDGCalendarModeWeek]];
	self.tableBottomVerticalDistanceConstraint = [NSLayoutConstraint constraintWithItem:self.tableContainerView
																			  attribute:NSLayoutAttributeBottom
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:self.view
																			  attribute:NSLayoutAttributeBottom
																			 multiplier:1.0f
																			   constant:0.f];

	[self.view addConstraint:self.tableBottomVerticalDistanceConstraint];
	[self.calendarContainerView addConstraint:self.calendarHeightConstraint];
}

- (void)initializeCalendar
{
	self.calendarController = [DGCalendarController new];
	[self.calendarController setDelegate:self];

	[self addChildViewController:self.calendarController];
	[self.calendarController willMoveToParentViewController:self];
	self.calendarView = self.calendarController.view;
	[self.calendarContainerView addSubview:self.calendarView];
	[self.calendarController didMoveToParentViewController:self];

	self.calendarView.translatesAutoresizingMaskIntoConstraints = NO;

	[self.calendarContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[calendar]-0-|"
																					   options:0
																					   metrics:nil
																						 views:@{ @"calendar" : self.calendarView }]];
	[self.calendarContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[calendar]-0-|"
																					   options:0
																					   metrics:nil
																						 views:@{ @"calendar" : self.calendarView }]];
}

- (void)initializeEvents
{
	self.eventsController = [DGEventsController new];
	self.eventsControllerView = self.eventsController.view;

	[self.tableContainerView addSubview:self.eventsControllerView];

	self.eventsControllerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[eventsControllerView]-0-|"
																					options:0
																					metrics:nil
																					  views:@{ @"eventsControllerView" : self.eventsControllerView }]];
	[self.tableContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[eventsControllerView]-0-|"
																					options:0
																					metrics:nil
																					  views:@{ @"eventsControllerView" : self.eventsControllerView }]];
}

- (void)initializeCalendarRequestManager
{
	self.calendarRequestManager = [[DGCalendarRequestManager alloc] initWithCalendarDataModel:self.dataModel];
	self.calendarRequestManager.calendarRequestDelegate = self;
}

- (void)initializeObservers
{
	[self addObserver:self forKeyPath:kViewMode options:0 context:nil];
	[self addObserver:self forKeyPath:kLastSelectedDate options:0 context:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processDayChange) name:kDGGlobalMidnightUpdate object:nil];
}

#pragma mark - Observer Methods

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	if (object == self && [keyPath isEqualToString:kViewMode])
		[self updateSwitchToolbarButton];

	else if (object == self && [keyPath isEqualToString:kLastSelectedDate])
		[self updateTodayToolbarButton];
}

#pragma mark - Update Methods

- (void)update
{
    [self updateToolbar];
    [self updateAlpha];
    [self requestServerEventsForDate:self.lastSelectedDate ?: self.dataModel.currentDate];
}

- (void)updateToolbar
{
	[self updateTodayToolbarButton];
	[self updateSwitchToolbarButton];
}

- (void)updateTodayToolbarButton
{
	if (self.lastSelectedDate) {

		BOOL isSameDay = [self.lastSelectedDate isSameDayAsDate:[NSDate now]];
		DGWeakify(self);
		[UIView animateWithDuration:kCalendarDefaultAnimationDuration
						 animations:^{
							 DGStrongify(self);
							 [self.todayBarButton.customView setAlpha:isSameDay ? .5f : 1.f];
						 }];
		[self.todayBarButton setEnabled:!isSameDay];
	}
}

- (void)updateSwitchToolbarButton
{
	DGWeakify(self);
	[UIView animateWithDuration:kCalendarDefaultAnimationDuration
					 animations:^{
						 DGStrongify(self);

						 UIView* view = [self.switchBarButton valueForKey:@"view"];

						 if (self.viewMode == kDGCalendarModeMonth) {
							 view.transform = CGAffineTransformMakeRotation(M_PI);
						 } else {
							 view.transform = CGAffineTransformMakeRotation(0);
						 }
					 }];
	// WIP: Rotation alternative
	//    UIImage *image = [self.switchBarButton valueForKey:@"image"];
	//    UIImage *imageRotated = nil;
	//    if (self.viewMode == kDGCalendarModeMonth) {
	//        imageRotated = [UIImage imageWithCGImage:image.CGImage scale:1.8 orientation:UIImageOrientationUp];
	//    } else {
	//        imageRotated = [UIImage imageWithCGImage:image.CGImage scale:1.8 orientation:UIImageOrientationDown];
	//    }
	//
	//    [self.switchBarButton setImage:imageRotated];
}

- (void)updateAlpha
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kCalendarDefaultAnimationDuration];
	[@[ self.calendarContainerView, self.tableContainerView ] enumerateObjectsUsingBlock:^(UIView* _Nonnull view, NSUInteger idx, BOOL* _Nonnull stop) {
		[view setAlpha:1.0];
	}];
	[UIView commitAnimations];
}

#pragma mark - Helper Methods

- (void)changeFont:(UIView*)parentView byFontName:(NSString*)fontName
{
	for (id view in [parentView subviews]) {
		if ([view isKindOfClass:[UILabel class]]) {
			UIFont* font = [UIFont fontWithName:fontName size:((UILabel*)view).font.pointSize];
			[((UILabel*)view) setFont:font];
		} else if ([view isKindOfClass:[UIView class]]) {
			[self changeFont:view byFontName:fontName];
		}
	}
}

- (void)switchCalendarMode
{
	[self.calendarController switchMode];
}

- (void)todayCalendarMode
{
	[self.calendarController updateWithSelectedDate:[[NSDate now] startOfDay]];
}

- (NSArray*)eventsFrom:(NSDate*)fromDate to:(NSDate*)toDate;
{
	NSDate* startDate = [fromDate startOfDay];
	NSDate* endDate = [toDate endOfDay];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", endDate, startDate];
	return [self.dataModel.events filteredArrayUsingPredicate:predicate];
}

- (NSArray*)passiveDaysFrom:(NSDate*)fromDate to:(NSDate*)toDate;
{
	NSDate* startDate = [fromDate startOfDay];
	NSDate* endDate = [toDate endOfDay];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", endDate, startDate];

	return [self.dataModel.passiveDays filteredArrayUsingPredicate:predicate];
}

- (void)processDateSelection:(NSDate*)date
{
	[self requestServerEventsForDate:date];
	self.lastSelectedDate = [date startOfDay];

	self.eventsForDate = [self eventsFrom:[date startOfDay] to:[date endOfDay]];

	[self.eventsController updateWithEvents:self.eventsForDate];
}

- (void)requestServerEventsForDate:(NSDate*)date
{
	if (self.calendarRequestManager) {
		[self.calendarController updateWithUIMode:kDGCalendarUIModeProcessing];
		[self.calendarRequestManager requestEventsForMonthContainingDate:date];
	}
}

- (UIImage*)drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point
{
	UIFont* font = [UIFont boldSystemFontOfSize:kCalendarDefaultToolbarButtonFontSize];
	NSDictionary* attribs = @{ NSForegroundColorAttributeName : self.toolbarButtonTintColor ?: [UIColor blackColor],
		NSFontAttributeName : font };
	UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
	[image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
	CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
	[text drawInRect:CGRectIntegral(rect) withAttributes:attribs];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return newImage;
}

- (void)processDayChange
{
	[self initializeToolbar];
	[self.calendarController smartReloadData];
}

#pragma mark - DGCalendarController Delegate Methods

- (void)calendarController:(DGCalendarController*)ctrl requiresMode:(DGCalendarMode)mode
{
	self.viewMode = mode;
}

- (void)calendarController:(DGCalendarController*)ctrl didChangeSelectedDate:(NSDate*)selectedDate
{
	if (self.requiresRefresh || !self.lastSelectedDate || (self.lastSelectedDate && ![selectedDate isSameDayAsDate:self.lastSelectedDate])) {

		self.requiresRefresh = NO;
		[self processDateSelection:selectedDate];
	}
}

- (void)calendarController:(DGCalendarController*)ctrl didChangeFocusedDate:(NSDate*)focusedDate
{
	if (self.requiresRefresh || !self.lastSelectedDate || (self.lastSelectedDate && ![focusedDate isSameDayAsDate:self.lastSelectedDate])) {

		self.requiresRefresh = NO;
		[self processDateSelection:focusedDate];
	}
}

- (NSArray*)calendarController:(DGCalendarController*)ctrl requiresEventsFrom:(NSDate*)fromDate to:(NSDate*)toDate
{
	return [self eventsFrom:fromDate to:toDate];
}

- (NSArray*)calendarController:(DGCalendarController*)ctrl requiresPassiveDaysFrom:(NSDate*)fromDate to:(NSDate*)toDate
{
	return [self passiveDaysFrom:fromDate to:toDate];
}

- (void)calendarController:(DGCalendarController*)ctrl didChangeSize:(CGSize)size
{
	self.calendarHeightConstraint.constant = size.height;

	DGWeakify(self);
	[UIView animateWithDuration:kCalendarDefaultAnimationDuration
					 animations:^{
						 DGStrongify(self);
						 [self.view layoutIfNeeded];
					 }];
}

#pragma mark - DGCalendarRequestManagerDelegate

- (void)calendarRequestManager:(DGCalendarRequestManager*)calendarRequestManager didReceiveEventsfromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
	DGWeakify(self);
	dispatch_async(dispatch_get_main_queue(), ^{
		DGStrongify(self);
		[self.calendarController smartReloadData];
		[self.calendarController updateWithUIMode:kDGCalendarUIModeStandBy];
	});
}

@end
