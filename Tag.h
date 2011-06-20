//
//  Tag.h
//  MilesTracker
//
//  Created by Mike Glazer on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;

@interface Tag :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* events;

@end


@interface Tag (CoreDataGeneratedAccessors)
- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)value;
- (void)removeEvents:(NSSet *)value;

@end

