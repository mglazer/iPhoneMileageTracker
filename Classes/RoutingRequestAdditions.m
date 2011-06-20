//
//  RoutingRequestAdditions.m
//  MilesTracker
//
//  Created by Mike Glazer on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RoutingRequestAdditions.h"
#import <TokenManager.h>


@implementation RoutingRequest(TokenBasedRoutingRequest) 
-(void) findRoute:(CLLocationCoordinate2D) from to:(CLLocationCoordinate2D) toPoint vehicle:(NSString*) object tokenManager:(TokenManager*)tokenManager
{
	NSString* strUrl = [self composeURL:from to:toPoint vechile:object];
	strUrl = [tokenManager appendRequestWithToken:strUrl];
	NSLog(@"url = %@\n",strUrl);
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:20.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}		
	
	
}
@end
