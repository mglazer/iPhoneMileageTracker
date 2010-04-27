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
#import "UITableAlert.h"
#import "UITableAlertDataSource.h"
#import "EventLocationMapAnnotation.h"


@implementation LocationSelectionViewController

@synthesize mapView;
@synthesize delegate;
@synthesize locationManager;
@synthesize forwardGeocoder;
@synthesize addressSearchBar;
@synthesize existingAddress;
@synthesize existingCoordinate;
@synthesize currentAnnotation;

@synthesize selectedAddress;
@synthesize selectedCoordinate;

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
		
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	
	if ( self.existingAddress != nil ) {
		[self addAnnotationAtLocation:self.existingCoordinate withAddress:self.existingAddress];


	}
}

- (void)addAnnotationAtLocation:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)address {
	
	if ( self.currentAnnotation != nil ) {
		[mapView removeAnnotation:self.currentAnnotation];
	}
	
	EventLocationMapAnnotation* annotation = [EventLocationMapAnnotation annotationWithCoordinate:coordinate];
	annotation.address = address;
		
	MKCoordinateRegion region;
	region.center = coordinate;
	region.span.longitudeDelta = 0.15f;
	region.span.latitudeDelta = 0.15f;
	
	[self.mapView setRegion:region animated:YES];
	
	
	[self.mapView addAnnotation:annotation];
		
	self.addressSearchBar.text = address;
}

- (void)findGeocodedSelectedLocation:(CLLocationCoordinate2D)coordinate {
	MKReverseGeocoder* reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coordinate] autorelease];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
	NSLog(@"Geocoding");
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
	[self.delegate didAcceptLocationSelection:self.selectedCoordinate withAddress:self.selectedAddress];
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
	
	
	// todo: geocode this result
	self.selectedCoordinate = newLocation.coordinate;
	[self findGeocodedSelectedLocation:self.selectedCoordinate];
	[self addAnnotationAtLocation:self.selectedCoordinate withAddress:@"Searching for address..."];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"There was an error %@", error.localizedDescription);
}

#pragma mark -
#pragma mark Geolocation

-(void) displayGeocodingResultOptions:(NSArray*)results {

	UITableAlert* alert = [[UITableAlert alloc] initWithTitle:@"Did you mean:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	alert.delegate = self;
	alert.alertDelegate = self;
	
	
	[alert show];
	[alert release];

}

-(void)updateLocation:(BSKmlResult*)place {
	// Zoom into the location		
	[mapView setRegion:place.coordinateRegion animated:TRUE];
	
	NSString* name = place.address;
	
	if ( name == nil ) {
		name = addressSearchBar.text;
	}
	
	self.selectedAddress = name;
	self.selectedCoordinate = [place coordinate];
	[self addAnnotationAtLocation:place.coordinate withAddress:name];
}

	


#pragma mark -
#pragma mark UITableAlert

- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ( forwardGeocoder.results ) {
		NSMutableArray* results = [[NSMutableArray alloc] init];
		
		int resultSize = [forwardGeocoder.results count];
		for ( int i = 0; i < resultSize; ++i ) {
			BSKmlResult* place = [forwardGeocoder.results objectAtIndex:i];
			[results addObject:place.address];
		}
		
		id data = [[UITableAlertDataSource alloc] initWithArray:results];	
		((UITableAlert *)alertView).tableData = data;
		
		[results release];
	}
}


-(void)tableAlert:(UITableAlert*)tableAlert didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	int row = indexPath.row;
	if ( forwardGeocoder.results && [forwardGeocoder.results count] > row ) {
		BSKmlResult* place = [forwardGeocoder.results objectAtIndex:row];
		[self updateLocation:place];
	}
	
	[tableAlert dismissWithClickedButtonIndex:0 animated:YES];
	
}


#pragma mark -
#pragma mark BSForwardGeocoder

-(void)forwardGeocoderFoundLocation {
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
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
#pragma mark MKReverseGeocoder

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	
	NSString* address = [NSString stringWithFormat:@"%s %s %s %s %s %s %s %s %s", 
		placemark.thoroughfare, placemark.subThoroughfare, placemark.locality,
		placemark.subLocality, placemark.administrativeArea, placemark.subAdministrativeArea,
						 placemark.postalCode, placemark.country, placemark.countryCode];
	
	NSLog(@"Current address: %@", address);
	self.selectedAddress = address;
	[self addAnnotationAtLocation:self.selectedCoordinate withAddress:address];
	
	[address release];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView* view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"address"];
	
	if ( view == nil ) {
		view = [[[MKPinAnnotationView alloc]
				 initWithAnnotation:annotation reuseIdentifier:@"address"] autorelease];
	}
	

	if ( [self.delegate isStartingPoint] ) {
		[view setPinColor:MKPinAnnotationColorGreen];
	} else {
		[view setPinColor:MKPinAnnotationColorRed];
	}
	
	[view setCanShowCallout:YES];
	[view setAnimatesDrop:YES];
	
	return view;
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
	
	[cancelButton release];
	[acceptButton release];
	[cancelMapEntryButton release];
	
	[forwardGeocoder release];
	[existingAddress release];
	[currentAnnotation release];
	
	[selectedAddress release];
		
    [super dealloc];
}


@end
