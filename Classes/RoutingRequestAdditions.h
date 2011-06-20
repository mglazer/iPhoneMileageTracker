//
//  RoutingRequestAdditions.h
//  MilesTracker
//
//  Created by Mike Glazer on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RoutingRequest.h>

@class TokenManager;

@interface RoutingRequest(TokenBasedRoutingRequest) 

-(void) findRoute:(CLLocationCoordinate2D) from to:(CLLocationCoordinate2D) toPoint vehicle:(NSString*) object tokenManager:(TokenManager*)tokenManager;

@end
