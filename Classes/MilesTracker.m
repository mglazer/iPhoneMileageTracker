//
//  MilesTracker.m
//  MilesTracker
//
//  Created by Mike Glazer on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MilesTracker.h"


@implementation MilesTracker


+(NSDateFormatter*) createDateFormatter {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterLongStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return formatter;
}
@end
