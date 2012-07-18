//
//  CNCategoryTableViewController.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPOIPool;

@interface CNCategoryTableViewController : UITableViewController
@property (nonatomic, weak) IBOutlet UIBarButtonItem *locateButton;

- (IBAction)startLocating:(id)sender;
- (IBAction)chooseFloorPlan:(id)sender;
@end
