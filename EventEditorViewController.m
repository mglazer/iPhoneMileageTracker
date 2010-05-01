//
//  EventEditorViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <RoutingRequest.h>

#import "EventEditNameViewController.h"
#import "EventEditorViewController.h"

#import "LocationSelectionViewController.h"
#import "Event.h"
#import "MilesTracker.h"
#import "MilesTrackerAppDelegate.h"
#import "UnitConverter.h"

#import <TokenManager.h>
#import <JsonRoutingParser.h>

@implementation RoutingRequest(TokenBasedRoutingRequest) 
-(void) findRoute:(CLLocationCoordinate2D) from to:(CLLocationCoordinate2D) toPoint vehicle:(NSString*) object tokenManager:(TokenManager*)tokenManager
{
	NSString* strUrl = [self composeURL:from to:toPoint vechile:object];
	strUrl = [tokenManager appendRequestWithToken:strUrl];
	NSLog(@"url = %@\n",strUrl);
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:20.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}		
	
	
}
@end



@implementation EventEditorViewController

@synthesize event;
@synthesize editingStartLocation;
@synthesize tableView;
@synthesize appDelegate;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStyleBordered	target:self action:@selector(cancel)];
	self.navigationItem.backBarButtonItem = cancelButtonItem;
	
	UIBarButtonItem *acceptButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = acceptButtonItem;
	
	tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
														  style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	tableView.delegate = self;
	tableView.dataSource = self;
	
	self.navigationItem.title = self.event.name;
	
	[tableView reloadData];
	
	self.view = tableView;	
	
	tokenManager_ = [MilesTracker createTokenManager];
	[tokenManager_ requestToken];
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

enum TableViewSections {
	SECTION_DISTANCE = 0,
	SECTION_NAME_START_END = 1,
	SECTION_DATE_CATEGORY = 2,
	SECTION_COUNT = 3
};

enum DistanceSectionRows {
	SECTION_DISTANCE_DISTANCE = 0,
	SECTION_DISTANCE_COUNT = 1
};

enum NameStartEndSectionRows {
	SECTION_NAME_START_END_NAME = 0,
	SECTION_NAME_START_END_START = 1,
	SECTION_NAME_START_END_END = 2,
	SECTION_NAME_START_END_COUNT = 3
};

enum SectionDateCategoryRows {
	SECTION_DATE_CATEGORY_DATE = 0,
	SECTION_DATE_CATEGORY_CATEGORY = 1,
	SECTION_DATE_CATEGORY_COUNT = 2
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ( section ) {
		case SECTION_DISTANCE:
			return SECTION_DISTANCE_COUNT;
		case SECTION_NAME_START_END:
			return SECTION_NAME_START_END_COUNT;
		case SECTION_DATE_CATEGORY:
			return SECTION_DATE_CATEGORY_COUNT;
	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	switch ( indexPath.section )
	{
		case SECTION_DISTANCE:
			cell = [self cellForDistanceSection:cell withRow:indexPath.row];
			break;
		case SECTION_NAME_START_END:
			cell = [self cellForNameSection:cell withRow:indexPath.row];
			break;
		case SECTION_DATE_CATEGORY:
			cell = [self cellForDateSection:cell withRow:indexPath.row];
			break;
	}
	
    return cell;
}

- (UITableViewCell*)cellForDistanceSection:(UITableViewCell*)cell withRow:(NSUInteger)row {
	
	NSNumber* localeDistance = [[appDelegate unitConverter] distanceToLocale:event.distance];
	[cell detailTextLabel].text = [NSString stringWithFormat:@"%.2f %@", [localeDistance floatValue], 
																		 [[appDelegate unitConverter] localeDistanceString]];
	[cell textLabel].text = @"Distance";
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
}

- (UITableViewCell*)cellForNameSection:(UITableViewCell*)cell withRow:(NSUInteger)row {
	switch ( row ) {
		case SECTION_NAME_START_END_NAME:
			[cell detailTextLabel].text = event.name;
			[cell textLabel].text = @"Name";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case SECTION_NAME_START_END_START:
			[cell detailTextLabel].text = event.startLocationDescription;
			[cell textLabel].text = @"Start";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case SECTION_NAME_START_END_END:
			[cell detailTextLabel].text = event.endLocationDescription;
			[cell textLabel].text = @"End";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
	}
	
	return cell;
}

- (UITableViewCell*)cellForDateSection:(UITableViewCell*)cell withRow:(NSUInteger)row {
	
	NSDateFormatter* formatter = [MilesTracker createDateFormatter];
	
	switch ( row ) {
		case SECTION_DATE_CATEGORY_DATE:
			[cell detailTextLabel].text = [formatter stringFromDate:event.timeStamp];
			[cell textLabel].text = @"Date";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case SECTION_DATE_CATEGORY_CATEGORY:
			[cell detailTextLabel].text = event.category;
			[cell textLabel].text = @"Category";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
	}

	
	[formatter release];
	return cell;
}


- (void)didSelectRowInDistanceSection:(NSUInteger)row {
}

- (void)didSelectRowInNameSection:(NSUInteger)row {
	
	if ( row == SECTION_NAME_START_END_NAME ) {
		EventEditNameViewController* editController = [[EventEditNameViewController alloc] initWithNibName:@"EventAddView" bundle:nil];
		editController.delegate = self;
		editController.name = event.name;
		editController.title = @"Edit Event Name";
		
		[self.navigationController pushViewController:editController animated:YES];
		
	} else {
		LocationSelectionViewController* nextController =  [[LocationSelectionViewController alloc] initWithNibName:@"LocationSelectionView" bundle:nil];
		nextController.delegate = self;
		self.editingStartLocation = (row == SECTION_NAME_START_END_START);
		
		UINavigationController* baseController = [[UINavigationController alloc] initWithRootViewController:nextController];
		//[self.navigationController pushViewController:nextController animated:YES];
		[self presentModalViewController:baseController	animated:YES];
		
		[nextController release];
		[baseController release];
	}
	
}

- (void)didSelectRowInDateSection:(NSUInteger)row {
	
	if ( row == SECTION_DATE_CATEGORY_DATE ) {
		DatePickerViewController* controller = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView"  bundle:nil];
		controller.delegate = self;
		controller.date = event.timeStamp;

		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ( indexPath.section ) {
		case SECTION_DISTANCE:
			[self didSelectRowInDistanceSection:indexPath.row];
			break;
		case SECTION_NAME_START_END:
			[self didSelectRowInNameSection:indexPath.row];
			break;
		case SECTION_DATE_CATEGORY:
			[self didSelectRowInDateSection:indexPath.row];
			break;
	}
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


#pragma mark -
#pragma mark LocationSelectionViewDelegate methods

- (bool)eventHasStartAndEndPositionsDefined {
	return self.event.startLocationLat != nil && self.event.startLocationLon != nil &&
	self.event.endLocationLat != nil && self.event.endLocationLon != nil;
}

- (void)updateDistanceFromEvent {

	CLLocationCoordinate2D startLocation;
	startLocation.latitude = [self.event.startLocationLat doubleValue];
	startLocation.longitude = [self.event.startLocationLon doubleValue];
	
	CLLocationCoordinate2D endLocation;
	endLocation.latitude = [self.event.endLocationLat doubleValue];
	endLocation.longitude = [self.event.endLocationLon doubleValue];
	
	RoutingRequest* request = [MilesTracker createRoutingRequest];
	request.delegate = self;
	[request findRoute:startLocation to:endLocation vehicle:@"car" tokenManager:tokenManager_];
	
	[request release];
	
}
	

- (void)didAcceptLocationSelection:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)name {
	//[self dismissModalViewControllerAnimated:YES];
	
	NSLog(@"User selected location %f:%f at %@", coordinate.latitude, coordinate.longitude, name);
	if ( self.editingStartLocation ) {
		self.event.startLocationLat = [NSNumber numberWithDouble:coordinate.latitude];
		self.event.startLocationLon = [NSNumber numberWithDouble:coordinate.longitude];
		self.event.startLocationDescription = name;		
	} else {
		self.event.endLocationLat = [NSNumber numberWithDouble:coordinate.latitude];
		self.event.endLocationLon = [NSNumber numberWithDouble:coordinate.longitude];
		self.event.endLocationDescription = name;
	}
	
	[tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
	if ( [self eventHasStartAndEndPositionsDefined] ) {
		[self updateDistanceFromEvent];
	}
}

- (bool)isStartingPoint {
	return self.editingStartLocation;
}


- (void)didCancelLocationSelection {
	[self dismissModalViewControllerAnimated:YES];
}
	
#pragma mark -
#pragma mark EventNameDelegate

- (void)eventEditNameViewController:(EventEditNameViewController*)source didSaveName:(NSString*)name {
	if ( name != nil ) {
		event.name = name;
		[tableView reloadData];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}
	
#pragma mark -
#pragma mark ServiceRequestResult
	
- (void) serviceServerResponse:(NSString *)jsonResponse {
	NSLog(@"%@", jsonResponse);
	JsonRoutingParser* parser = [[JsonRoutingParser alloc] init];
	
	if ( [parser responceStatus:jsonResponse] ) {
		RouteSummary* result = [parser routeSummury:jsonResponse];
		event.distance = [NSNumber numberWithFloat:(float)result.totalDistance];
		
		[tableView reloadData];
		[result release];
	}
	
	
	[parser release];
}

- (void) serviceServerError:(NSString *)error {
	NSLog(@"Error: %@", error);
}

#pragma mark -
#pragma mark Saving and cancelling

- (void)save {
	NSError* error;
	if ( ![event.managedObjectContext save:&error] ) {
		// TODO: Replace with better error handling code
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		abort();
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark DatePickerViewControllerDelegate

-(void) datePickerAcceptedDateSelection:(NSDate*)date {
	event.timeStamp = date;
	
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) datePickerCancelDateSelection {
	[self.navigationController popViewControllerAnimated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[event release];
	[tableView release];
    [super dealloc];
}


@end

