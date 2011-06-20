//
//  MilesTracker.m
//  MilesTracker
//
//  Created by Mike Glazer on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MilesTracker.h"

#import <RoutingRequest.h>
#import <TokenManager.h>


#define API_KEY @"7b2a52c41f77434cb0afeff0f6c24cba"

static MilesTracker *sharedInstance = nil;

@implementation MilesTracker


+(NSDateFormatter*) createDateFormatter {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterLongStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return formatter;
}

+(RoutingRequest*) createRoutingRequest {
	return [[RoutingRequest alloc] initWithApikey:API_KEY];
}

-(TokenManager*) tokenManager {
	if ( tokenManager != nil ) {
		return tokenManager;
	}
	
	tokenManager = [[TokenManager alloc] initWithApikey:API_KEY];
	[tokenManager requestToken];
	
	return tokenManager;
}




#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark Singleton methods

+ (MilesTracker*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[MilesTracker alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
