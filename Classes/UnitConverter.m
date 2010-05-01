//
//  UnitConverter.m
//  MilesTracker
//
//  Created by Mike Glazer on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UnitConverter.h"


@implementation UnitConverter

@synthesize metric;

- (id)initWithLocale:(NSLocale*)locale {
	self = [super init];
	if ( nil != self ) {
		self.metric = [(NSNumber*)[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
	}
	
	return self;
}

#define M_TO_MILES 0.000621371192
#define MILES_TO_M 1609.344

- (NSNumber*)distanceFromLocale:(NSNumber*)localeDistance {
	float distance = [localeDistance floatValue];
	if ( self.metric ) {
		return [NSNumber numberWithFloat:(distance * 1000.0)];
	} else {
		return [NSNumber numberWithFloat:(distance * MILES_TO_M)];
	}
}
- (NSNumber*)distanceToLocale:(NSNumber*)distance {
	float fdistance = [distance floatValue];
	if ( self.metric ) {
		return [NSNumber numberWithFloat:(fdistance / 1000.0)];
	} else {
		return [NSNumber numberWithFloat:(fdistance * M_TO_MILES)];
	}
}

- (NSString*)localeDistanceString {
	if ( self.metric ) {
		return @"km";
	} else {
		return @"mi";
	}
}

@end
