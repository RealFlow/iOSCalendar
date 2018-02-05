//
//  DGEventsController.m
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#import "DGEventsController.h"
#import "DGEventCell.h"
#import "DGCalendarEvent.h"

#define kEventsTableSectionHeight 1
#define kEventsTableEstimatedRowHeight 56

static NSString* const cellID = @"cell";

@interface DGEventsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<DGCalendarEvent*>* events;

@end

@implementation DGEventsController


- (void)viewDidLoad
{
	[super viewDidLoad];

	[self initializeEventsTable];
}

- (void)dealloc
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Initialization Methods

- (void)initializeEventsTable
{
	[self.tableView registerNib:[UINib nibWithNibName:@"DGEventCell" bundle:nil] forCellReuseIdentifier:cellID];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.sectionHeaderHeight = kEventsTableSectionHeight;
	self.tableView.estimatedRowHeight = kEventsTableEstimatedRowHeight;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Update Methods

- (void)updateWithEvents:(NSArray<DGCalendarEvent*>*)events
{
	self.events = events;

	[self.tableView reloadData];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.events.count ?: 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	DGEventCell* cell = (DGEventCell*)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!self.events.count) {
//        cellDM = [[ListCellDM alloc] init];
//        cellDM.name = NSLocalizedString(@"No Events", nil);
    } else {
        DGCalendarEvent* event = self.events[indexPath.row];
        [cell updateWithEvent:event];
    }
    
	CGRect frameCell = cell.frame;
	frameCell.size = CGSizeMake(self.tableView.frame.size.width, frameCell.size.height);
	cell.frame = frameCell;

//    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
//    cell.delegate = cell;
//
//    cell.cellDM = cellDM;
//    cell.parentView = tableView;
//    cell.cellIndexPath = indexPath;
//
//    NSURL* imageURL = [NSURL URLWithString:cellDM.iconLink.href];
//    [self loadImageURL:imageURL onCell:cell];
//
//    [cell composeViewForFormMode:formModeReadOnly];
//    cell.parentVC = self;

	return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	return kEventsTableSectionHeight;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
