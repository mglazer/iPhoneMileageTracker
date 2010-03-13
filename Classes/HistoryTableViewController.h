//
//  RootViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@class MilesTrackerAppDelegate;

@interface HistoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	UINavigationController* navigationController;
	MilesTrackerAppDelegate* delegate;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@property (nonatomic, retain) IBOutlet MilesTrackerAppDelegate* delegate;

@end
