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

+(TokenManager*) createTokenManager {
	return [[TokenManager alloc] initWithApikey:API_KEY];
}

@end
