//
//  Event.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * endLocationLat;
@property (nonatomic, retain) NSNumber * endLocationLon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * endLocationDescription;
@property (nonatomic, retain) NSNumber * startLocationLat;
@property (nonatomic, retain) NSString * startLocationDescription;
@property (nonatomic, retain) NSNumber * roundTrip;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * startLocationLon;

@end



