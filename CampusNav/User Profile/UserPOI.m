//
//  UserPOI.m
//  CampusNav
//
//  Created by Greg Wang on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPOI.h"
#import "GGSystem.h"

@implementation UserPOI

@dynamic displayName;
@dynamic pId;
@dynamic order;

- (GGPOI *)poi
{
	return [GGPOI poiWithPId:self.pId];
}

@end
