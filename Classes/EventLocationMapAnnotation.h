//
//  EventLocationMapAnnotation.h
//  MilesTracker
//
//  Created by Mike Glazer on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MKAnnotation;

@interface EventLocationMapAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString* address;
}

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString* address;
@end
