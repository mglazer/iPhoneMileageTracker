//
//  EventLocationMapAnnotation.m
//  MilesTracker
//
//  Created by Mike Glazer on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "EventLocationMapAnnotation.h"




@implementation EventLocationMapAnnotation

@synthesize coordinate;
@synthesize address;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
	return [[[[self class] alloc] initWithCoordinate:coordinate] autorelease];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	self = [super init];
	if ( nil != self ) {
		self.coordinate = coordinate;
	}
	
	return self;
}

- (NSString*)title {
	return self.address;
}

- (void)dealloc {
	[address release];
	[super dealloc];
}



@end
