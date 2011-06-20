//
//  Event.h
//  MilesTracker
//
//  Created by Mike Glazer on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Tag;

@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSString * endLocationDescription;
@property (nonatomic, retain) NSNumber * startLocationLat;
@property (nonatomic, retain) NSNumber * roundTrip;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * endLocationLon;
@property (nonatomic, retain) NSNumber * endLocationLat;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * startLocationDescription;
@property (nonatomic, retain) NSNumber * startLocationLon;
@property (nonatomic, retain) NSSet* tags;

@end


@interface Event (CoreDataGeneratedAccessors)
- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)value;
- (void)removeTags:(NSSet *)value;

@end

