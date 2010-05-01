//
//  MilesTrackerAppDelegate.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@class UnitConverter;

@interface MilesTrackerAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    UITabBarController *tabBarController;
	
	UnitConverter* unitConverter;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) UnitConverter* unitConverter;

- (NSString *)applicationDocumentsDirectory;


@end

