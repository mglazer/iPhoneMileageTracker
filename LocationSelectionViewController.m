//
//  LocationSelectionViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationSelectionViewController.h"
#import "CoreLocation/CLLocation.h"
#import "CoreLocation/CLLocationManager.h"


@implementation LocationSelectionViewController

@synthesize mapView;
@synthesize delegate;
@synthesize currentLocation;
@synthesize locationManager;
@synthesize forwardGeocoder;
@synthesize addressSearchBar;
@synthesize lastResults;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView {


}
 */

- (void)switchToNavigationMapButtons {
	self.navigationItem.leftBarButtonItem = cancelButton;
	self.navigationItem.rightBarButtonItem = acceptButton;
}

- (void)switchToMapInteractionButtons {
	[self.navigationItem setHidesBackButton:YES];
	[self.navigationItem setRightBarButtonItem:cancelMapEntryButton animated:YES];
	//self.navigationItem.leftBarButtonItem = cancelMapEntryButton;
	//self.navigationItem.rightBarButtonItem = clearMapEntryButton;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered	target:self action:@selector(cancel)];
	acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleBordered target:self action:@selector(accept)];
	cancelMapEntryButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelMapSelect)];
	
	[self switchToNavigationMapButtons];
	
	self.navigationItem.title = @"Choose Location";
	
	self.currentLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)findCurrentLocationClicked {
	NSLog(@"Updating location");
	[self.locationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark Actions
- (void)accept {
	[self.delegate didAcceptLocationSelection];
}

- (void)cancel {
	[self.delegate didCancelLocationSelection];
}

- (void)cancelMapSelect {
	[self switchToNavigationMapButtons];
}


#pragma mark -
#pragma mark Begin Search Bar Delegate methods

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	//[self switchToNavigationMapButtons];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	if ( forwardGeocoder == nil ) {
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	[forwardGeocoder findLocation:searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	
	//[self switchToMapInteractionButtons];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	//[searchBar resignFirstResponder];
}




- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	// wait until location was updated
	return YES;
}



#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
	
	[currentLocation release];
	currentLocation = newLocation;
	
	[self.delegate didSelectLocation:@"Some location" withCoordinate:currentLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"There was an error %@", error.localizedDescription);
}

#pragma mark -
#pragma mark Geolocation

-(void) displayGeocodingResultOptions:(NSArray*)results {

	UIAlertView* alert = [[UIAlertView alloc] init];
	
	alert.delegate = self;
	alert.title = @"Choose address";
	
	int numResults = [results count];
	for ( int i = 0; i < numResults; ++i ) {
		BSKmlResult* place = [results objectAtIndex:i];
		[alert addButtonWithTitle:place.address];
	}
	
	[alert show];

}

-(void)updateLocation:(BSKmlResult*)place {
	// Zoom into the location		
	[mapView setRegion:place.coordinateRegion animated:TRUE];
	
	NSString* name = place.address;
	
	if ( name == nil ) {
		name = addressSearchBar.text;
	}
	
	[self.delegate didSelectLocation:name withCoordinate:[place coordinate]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( lastResults && [lastResults count] > buttonIndex ) {
		BSKmlResult* place = [lastResults objectAtIndex:buttonIndex];
		[self updateLocation:place];
	}
}



-(void)forwardGeocoderFoundLocation {
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		lastResults = forwardGeocoder.results;
		int searchResults = [forwardGeocoder.results count];
		
		// Dismiss the keyboard
		[addressSearchBar resignFirstResponder];
		

		
		if([forwardGeocoder.results count] == 1)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
			[self updateLocation:place];
		}
		else
		{
			[self displayGeocodingResultOptions:forwardGeocoder.results];
		}

	}
	
}

-(void)forwardGeocoderError:(NSString *)errorMessage {
	NSLog(errorMessage);
}


#pragma mark -
#pragma mark Deallocation 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[addressSearchBar release];
	[mapView release];
	[currentLocation release];
	
	[cancelButton release];
	[acceptButton release];
	[cancelMapEntryButton release];
	
	[forwardGeocoder release];
	
    [super dealloc];
}


@end
