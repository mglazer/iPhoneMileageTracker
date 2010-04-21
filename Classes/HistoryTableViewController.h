//
//  RootViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EventAddViewController.h"


@class MilesTrackerAppDelegate;
@class EventEditorViewController;
@class Event;

@interface HistoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, EventAddDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	UINavigationController* navigationController;
	MilesTrackerAppDelegate* delegate;
	UITableViewCell* nibLoadedCell;
	EventEditorViewController* eventEditor;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@property (nonatomic, retain) IBOutlet MilesTrackerAppDelegate* delegate;

@property (nonatomic, retain) IBOutlet UITableViewCell* nibLoadedCell;

@property (nonatomic, retain) IBOutlet EventEditorViewController* eventEditor;

- (void)addEvent;

- (void)showEvent:(Event*)event animated:(BOOL)animated;

@end
