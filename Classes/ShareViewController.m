//
//  ShareViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

#import "ShareViewController.h"
#import "Event.h"
#import "MilesTracker.h"
#import "MilesTrackerAppDelegate.h"
#import "UnitConverter.h"


@implementation ShareViewController

@synthesize nibLoadedCell, appDelegate;

enum TableViewSections {
	SECTION_DATES,
	SECTION_FORMAT,
	SECTION_SEND,
	SECTION_COUNT
};

enum DatesSectionRows {
	SECTION_DATES_START,
	SECTION_DATES_END,
	SECTION_DATES_COUNT
};

enum FormatSectionRows {
	SECTION_FORMAT_FORMAT,
	SECTION_FORMAT_COUNT
};

enum SendSectionRows {
	SECTION_SEND_SEND,
	SECTION_SEND_COUNT
};

#pragma mark Service methods

- (NSDate*)findEarliestDate {
	
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSString* predFormat = @"timeStamp = min(timeStamp)";
	NSPredicate *pred = [NSPredicate predicateWithFormat:predFormat];
	[fetchRequest setPredicate:pred];
	
	NSError* error;
	NSArray* values = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
	
	if ( [values count] != 0 ) {
		Event* event = [values objectAtIndex:0];
		NSDate* earliestDate = [event valueForKey:@"timeStamp"];
		
		return earliestDate;
	} else {
		return [NSDate date];
	}
	
}
	
- (NSArray*)allTripsWithStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate andCategory:(NSString*)category {
	
	/*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp >= %@ and timeStamp <= %@", startDate,endDate];
	[fetchRequest setPredicate:predicate];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	
	NSError* error = nil;
	NSArray* values = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	
	if ( values == nil ) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[[error userInfo] description]
													   delegate:nil 
											  cancelButtonTitle:@"Close"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		values = nil;
	}
	
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	//[predicate release];
	
	return values;
}

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
		
	footerView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,24)];
	footerView.text = @"";
	footerView.textAlignment = UITextAlignmentCenter;
	footerView.textColor = [UIColor greenColor];
	footerView.backgroundColor = [UIColor clearColor];
	
	self.tableView.tableFooterView = footerView;
	

	startDate_ = [[self findEarliestDate] retain];
	endDate_ = [[NSDate date] retain];
	canSendEmail_ =  [MFMailComposeViewController canSendMail];
	
		
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

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
	
	appDelegate = nil;
}

- (NSManagedObjectContext*)managedObjectContext {
	return appDelegate.managedObjectContext;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch ( section ) {
		case SECTION_DATES:
			return SECTION_DATES_COUNT;
		case SECTION_FORMAT:
			return SECTION_FORMAT_COUNT;
		case SECTION_SEND:
			return SECTION_SEND_COUNT;
		default: 
			return 0;
	}
	
}


- (UITableViewCell *)cellForDatesSection:(UITableView*)tableView withRow:(NSUInteger)row {
	static NSString *CellIdentifier = @"DateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDateFormatter* formatter = [MilesTracker createDateFormatter];
	

	switch ( row ) {
		case SECTION_DATES_START:
			[cell detailTextLabel].text = [formatter stringFromDate:startDate_];
			[cell textLabel].text = @"Start";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case SECTION_DATES_END:
			[cell detailTextLabel].text = [formatter stringFromDate:endDate_];
			[cell textLabel].text = @"End";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
	}
	
	[formatter release];
	//[today release];
	
	return cell;
}

- (UITableViewCell *)cellForFormatSection:(UITableView*)tableView withRow:(NSUInteger)row {
	static NSString *CellIdentifier = @"ToCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	format_ = @"CSV";
	
	[cell detailTextLabel].text = format_;
	[cell textLabel].text = @"Format";
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

- (UITableViewCell *)cellForSendSection:(UITableView*)tableView withRow:(NSUInteger)row {
	static NSString *CellIdentifier = @"SendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SendTableViewCell" owner:self options:nil];
		cell = nibLoadedCell;
		self.nibLoadedCell = nil;
    }
	
	return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell* cell = nil;

    switch ( indexPath.section ) {
		case SECTION_DATES:
			cell = [self cellForDatesSection:tableView withRow:indexPath.row];
			break;
		case SECTION_FORMAT:
			cell = [self cellForFormatSection:tableView withRow:indexPath.row];
			break;
		case SECTION_SEND:
			cell = [self cellForSendSection:tableView withRow:indexPath.row];
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowInDatesSection:(NSUInteger)row {
	
	DatePickerViewController* nextController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
	nextController.delegate = self;
	
	
	UINavigationController* baseController = [[UINavigationController alloc] initWithRootViewController:nextController];
	
	[self presentModalViewController:baseController	animated:YES];

	
	switch ( row ) {
		case SECTION_DATES_START:
			nextController.date = startDate_;
			editingStartDate_ = YES;
			break;
		case SECTION_DATES_END:
			nextController.date = endDate_;
			editingStartDate_ = NO;
			break;
	}
	
		
	[nextController release];	
	[baseController release];
}


- (void)tableView:(UITableView *)tableView didSelectRowInFormatSection:(NSUInteger)row {
	
}





#pragma mark -
#pragma mark Writing Data and Sending Email

- (NSData*)writeCSVFormattedData {
	NSMutableData* data = [[NSMutableData alloc] initWithLength:4096];
	
	NSArray* arrResults = [self allTripsWithStartDate:startDate_ andEndDate:endDate_ andCategory:nil];
	
	if ( !arrResults ) {
		return data;
	}
	
	NSEnumerator* enumerator = [arrResults objectEnumerator];
	Event* event = nil;
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	
	NSString* header = [[NSString alloc] initWithFormat:@"Date,Name,Start Location,End Location,Distance (%@)\n",
						[[appDelegate unitConverter] localeDistanceString]];
	[data appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
	
	while ( (event = [enumerator nextObject]) ) {
		if ( !event.distance || !event.startLocationDescription || !event.endLocationDescription ) {
			continue;
		}
		
		NSMutableString* line = [[NSMutableString alloc] initWithCapacity:128];
		[line appendString:[formatter stringFromDate:event.timeStamp]];
		[line appendString:@","];
		[line appendString:event.name];
		[line appendString:@",\""];
		[line appendString:event.startLocationDescription];
		[line appendString:@"\",\""];
		[line appendString:event.endLocationDescription];		
		[line appendString:@"\","];
		
		NSNumber* distance = [[appDelegate unitConverter] distanceToLocale:event.distance];
		NSString* distanceStr = [[NSString alloc] initWithFormat:@"%.1f", [distance floatValue]];
		[line appendString:distanceStr];
		[line appendString:@"\n"];
		
		[data appendData:[line dataUsingEncoding:NSUTF8StringEncoding]];
		
		[distanceStr release];
		[line release];
	}
	
	[header release];
	[formatter release];
	return data;
}
	

- (NSData*)writeFormattedData {

	if ( [format_ compare:@"CSV"] == NSOrderedSame ) {
		return [self writeCSVFormattedData];
	}
	
	return nil;
}
	
-(NSString*) mimeType {
	
	if ( [format_ compare:@"CSV"] == NSOrderedSame ) {
		return @"text/csv";
	}
	
	return @"application/text";
}


- (void)sendMail {

	MFMailComposeViewController* composer = [[MFMailComposeViewController alloc] init];
	
	NSDateFormatter* formatter = [MilesTracker createDateFormatter];
	
	NSString* startDateFormatted = [formatter stringFromDate:startDate_];
	NSString* endDateFormatted = [formatter stringFromDate:endDate_];
	
	NSData* attachmentData = [self writeFormattedData];
	
	
	[composer setSubject:[NSString stringWithFormat:@"Tracked mileage from %@-%@", startDateFormatted, endDateFormatted]];
	[composer setMessageBody:@"Tracked Mileage Attached" isHTML:NO];
	
	[composer addAttachmentData:attachmentData mimeType:[self mimeType] fileName:@"milage.csv"];
	composer.mailComposeDelegate = self;
	
	[self presentModalViewController:composer animated:YES];
	
	[composer release];
	[formatter release];
	[attachmentData release];
}

- (void)tableView:(UITableView *)tableView didSelectRowInSendSection:(NSUInteger)row {
	
	if ( canSendEmail_ ) {
		[self sendMail];
	}
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	switch ( indexPath.section ) {
		case SECTION_DATES:
			[self tableView:tableView didSelectRowInDatesSection:indexPath.row];
			break;
		case SECTION_FORMAT:
			[self tableView:tableView didSelectRowInFormatSection:indexPath.row];
			break;
		case SECTION_SEND:
			[self tableView:tableView didSelectRowInSendSection:indexPath.row];
			break;
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ( section == 0 ) {
		UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,130,22)];
		label.backgroundColor=[UIColor clearColor];
		label.text = @"Share Events";
		
		label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
		[topView addSubview:label];
		
		return topView;
		
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	if ( section == 0 ) {
		return 30;
	}
	
	return 0;
	
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

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	
	if ( result == MFMailComposeResultSent ) {
		footerView.text = @"Sent";
		footerView.textColor = [UIColor greenColor];
	} else if ( result == MFMailComposeResultFailed ) {
		NSLog(@"Failed with error %@", [error userInfo]);
		NSString* errorText = [[NSString alloc] initWithFormat:@"Error: %@", [error userInfo]];
		footerView.text = errorText;
		footerView.textColor = [UIColor redColor];
		
		[errorText release];
	} else {
		footerView.text = @"";
	}
}


#pragma mark -
#pragma mark DatePickerViewControllerDelegate

-(void) datePickerAcceptedDateSelection:(NSDate*)date {
	if ( editingStartDate_ ) {
		[startDate_ release];
		startDate_ = [date retain];
	} else {
		[endDate_ release];
		endDate_ = [date retain];
	}
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

-(void) datePickerCancelDateSelection {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
	
	[startDate_ release];
	[endDate_ release];
	[footerView release];
}


@end

