//
//  RootViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "MilesTrackerAppDelegate.h"
#import "EventEditorViewController.h"
#import "EventEditNameViewController.h"
#import "Event.h";

#import "UnitConverter.h"


@implementation HistoryTableViewController

@synthesize fetchedResultsController, managedObjectContext;
@synthesize navigationController;
@synthesize delegate;
@synthesize nibLoadedCell;
@synthesize eventEditor;


enum HistoryCellTags {
	HISTORY_CELL_TAG_NAME = 1,
	HISTORY_CELL_TAG_DATE = 2,
	HISTORY_CELL_TAG_DISTANCE = 3
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.navigationItem.title = @"History";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	self.managedObjectContext = delegate.managedObjectContext;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Add a new object

- (void)addEvent {
	
	EventEditNameViewController* controller = [[EventEditNameViewController alloc] initWithNibName:@"EventAddView" bundle: nil];
	controller.delegate = self;
	controller.name = @"";
	controller.title = @"Add Event";
	
	UINavigationController *addEventNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:addEventNavigationController animated:YES];
    
    [addEventNavigationController release];
    [controller release];

}

#pragma mark -
#pragma mark EventAddDelegate methods

- (void)eventEditNameViewController:(EventEditNameViewController*)source didSaveName:(NSString*)name {
	
	Event* event = nil;
	
	if ( name == nil ) {
		// they hit cancel instead of save
	} else {
		// Create a new instance of the entity managed by the fetched results controller.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
		
		// If appropriate, configure the new managed object.
		[event setValue:[NSDate date] forKey:@"timeStamp"];
		[event setValue:name forKey:@"name"];
		
		NSError* error;
		if ( ![event.managedObjectContext save:&error] ) {
			// TODO: Replace with better error handling code
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			abort();
		}
	}
		
	if ( event ) {
		[self showEvent:event animated:NO];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)showEvent:(Event*)event animated:(BOOL)animated {
	EventEditorViewController* controller = [[EventEditorViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	controller.event = event;
	controller.appDelegate = delegate;
	//controller.navigationController = self.navigationController;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"HistoryViewTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"HistoryViewTableCell" owner:self options:nil];
		cell = nibLoadedCell;
		self.nibLoadedCell = nil;
    }
	
	NSManagedObject* managedObject = [fetchedResultsController objectAtIndexPath:indexPath];

	// Configure the cell.	
	UILabel* nameLabel = (UILabel*)[cell viewWithTag:HISTORY_CELL_TAG_NAME];
	nameLabel.text = [[managedObject valueForKey:@"name"] description];
	
	UILabel* dateLabel = (UILabel*)[cell viewWithTag:HISTORY_CELL_TAG_DATE];
	dateLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
	
	UILabel* distanceLabel = (UILabel*)[cell viewWithTag:HISTORY_CELL_TAG_DISTANCE];
	
	NSNumber* distanceNumber = (NSNumber*)[managedObject valueForKey:@"distance"];
	
	if ( distanceNumber == nil ) {
		distanceLabel.text = @"0.0";
	} else {
		NSNumber* convertedNumber = [[delegate unitConverter] distanceToLocale:distanceNumber];
		distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", 
							  [convertedNumber floatValue], 
							  [[delegate unitConverter] localeDistanceString]];
	}
    
	NSLog(@"Finished setting all labels");

	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	EventEditorViewController* controller = [[EventEditorViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	Event* event = (Event*)[[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	controller.event = event;
	controller.appDelegate = delegate;

	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
	*/
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.

// Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	// Update the table view appropriately.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	// Update the table view appropriately.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
} 
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

