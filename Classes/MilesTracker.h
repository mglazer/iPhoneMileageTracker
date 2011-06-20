//
//  MilesTracker.h
//  MilesTracker
//
//  Created by Mike Glazer on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenManager;
@class RoutingRequest;

@interface MilesTracker : NSObject {
	TokenManager* tokenManager;

}

+ (NSDateFormatter*)createDateFormatter;

+ (RoutingRequest*)createRoutingRequest;

- (TokenManager*)tokenManager;

+ (MilesTracker*)sharedInstance;

@end
