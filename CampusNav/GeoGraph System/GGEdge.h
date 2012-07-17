//
//  GGEdge.h
//  CampusNav
//
//  Created by Greg Wang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GGPoint;

@interface GGEdge : NSObject

@property (nonatomic, assign, readonly) NSInteger eId;
@property (nonatomic, retain, readonly) GGPoint *vertexA;
@property (nonatomic, retain, readonly) GGPoint *vertexB;
@property (nonatomic, assign, readonly) NSInteger weight;

@end
