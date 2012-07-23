//
//  CNNavConfigViewController.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNNavConfigViewController.h"
#import "CNNavResultViewController.h"

#import "CNPOICell.h"
#import "CNUICustomize.h"

#import "GGSystem.h"
#import "CNPathCalculator.h"
#import "CNSameFloorPathCalculator.h"

NSString * const kCNNavConfigNotification = @"CNNavConfigNotification";
NSString * const kCNNavConfigNotificationType = @"CNNavConfigNotificationType";
NSString * const kCNNavConfigNotificationData = @"CNNavConfigNotificationData";

NSString * const kCNNavConfigTypeSource = @"CNNavConfigTypeSource";
NSString * const kCNNavConfigTypeDestination = @"CNNavConfigTypeDestination";

@interface CNNavConfigViewController ()

@end

@implementation CNNavConfigViewController

#pragma mark - Getter & Setter
@synthesize sourcePOI = _sourcePOI;
@synthesize destinationPOI = _destinationPOI;

@synthesize navSourceCell = _navSourceCell;
@synthesize navDestinationCell = _navDestinationCell;
@synthesize startNavCell = _startNavCell;

#pragma mark - View controller events

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNavConfigNotification:) name:kCNNavConfigNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CNUICustomize customizeViewController:self];
	
	[self.navSourceCell clearCellWithPrompt:@"Please choose a source point"];
	[self.navDestinationCell clearCellWithPrompt:@"Please choose a destination point"];
	
	self.startNavCell.userInteractionEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.sourcePOI != nil) {
		[self.navSourceCell fillCellWithPOI:self.sourcePOI];
	}
	if (self.destinationPOI != nil) {
		[self.navDestinationCell fillCellWithPOI:self.destinationPOI];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleNavConfigNotification:(NSNotification *)notification
{
	NSDictionary *info = notification.userInfo;
	NSString *type = [info objectForKey:kCNNavConfigNotificationType];
	GGPOI *poi = [info objectForKey:kCNNavConfigNotificationData];
	
	if (type == kCNNavConfigTypeSource) {
		self.sourcePOI = poi;
	}
	else if (type == kCNNavConfigTypeDestination) {
		self.destinationPOI = poi;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	self.tabBarController.selectedViewController = self.navigationController;
	
	if (self.sourcePOI != nil && self.destinationPOI != nil) {
		self.startNavCell.userInteractionEnabled = YES;
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Actions

- (IBAction)startNav:(id)sender
{
	[self performSegueWithIdentifier:@"ShowNavResult" sender:sender];
}

#pragma mark - Segue

- (NSArray *)navResultForCurrentConfig
{
	NSArray *result = nil;
	if ([self.sourcePOI.edge.eId isEqualToNumber:self.destinationPOI.edge.eId]) {
		// The destination is right accross the hall way
		NSLog(@"Navigation over same edge");
	}
	else if ([self.sourcePOI.floorPlan.fId isEqualToNumber:self.destinationPOI.floorPlan.fId]) {
		CNPathCalculator *calculator = [[CNSameFloorPathCalculator alloc] initFromPOI:self.sourcePOI toPOI:self.destinationPOI];
		result = [calculator executeCalculation];
	}
	else if ([self.sourcePOI.floorPlan.building.name isEqualToString:self.destinationPOI.floorPlan.building.name]) {
		NSLog(@"Navigation between different floor");
	}
	else {
		NSLog(@"Navigation between different building");
	}
	return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowNavResult"]) {
		NSArray *result = [self navResultForCurrentConfig];
		
		CNNavResultViewController *vc = segue.destinationViewController;
		vc.resultPoints = result;
	}
}
@end
