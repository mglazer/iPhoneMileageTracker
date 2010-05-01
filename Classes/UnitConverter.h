//
//  UnitConverter.h
//  MilesTracker
//
//  Created by Mike Glazer on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UnitConverter : NSObject {
	bool metric;
}

@property (nonatomic,assign) bool metric;

- (NSNumber*)distanceFromLocale:(NSNumber*)localeDistance;
- (NSNumber*)distanceToLocale:(NSNumber*)distance;
- (NSString*)localeDistanceString;

- (id)initWithLocale:(NSLocale*)locale;

@end
