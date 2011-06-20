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
@synthesize updateLocationButton;
@synthesize toolbar;

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

- (void)createLocationButtons {
	coordinateSelectionImage = [UIImage imageNamed:@"location.png"];
	updateLocationButton = [[UIBarButtonItem alloc] initWithImage:coordinateSelectionImage style:UIBarButtonItemStyleBordered target:self action:@selector(findCurrentLocationClicked)];
	
	UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[activityIndicator startAnimating];
	
	findingLocationButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	findingLocationButton.style = UIBarButtonItemStyleDone;
	
	//[activityIndicator release];
	[coordinateSelectionImage release];
}

- (void)switchToFindingLocationButton {
	NSArray* buttons = [[NSArray alloc] initWithObjects:findingLocationButton,nil];
	[self.toolbar setItems:buttons animated:YES];
	[buttons release];
}

- (void)switchToUpdateLocationButton {
	NSArray* buttons = [[NSArray alloc] initWithObjects:updateLocationButton,nil];
	[self.toolbar setItems:buttons animated:YES];
	[buttons release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered	target:self action:@selector(cancel)];
	acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(accept)];
	cancelMapEntryButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelMapSelect)];
	
	[self switchToNavigationMapButtons];
	
	self.navigationItem.title = @"Choose Location";
		
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	
	[self createLocationButtons];
	[self switchToUpdateLocationButton];
	
	if ( self.existingAddress != nil ) {
		[self addAnnotationAtLocation:self.existingCoordinate withAddress:self.existingAddress];
		self.selectedAddress = self.existingAddress;
		self.selectedCoordinate = self.existingCoordinate;

	}
}

- (void)addAnnotationAtLocation:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)address {
	
	if ( self.currentAnnotation != nil ) {
		[mapView removeAnnotation:currentAnnotation];
	}
	
	currentAnnotation = [EventLocationMapAnnotation annotationWithCoordinate:coordinate];
	currentAnnotation.address = address;
		
	MKCoordinateRegion region;
	region.center = coordinate;
	region.span.longitudeDelta = 0.15f;
	region.span.latitudeDelta = 0.15f;
	
	[self.mapView setRegion:region animated:YES];
	
	
	[self.mapView addAnnotation:currentAnnotation];
		
	self.addressSearchBar.text = address;
}

- (void)findGeocodedSelectedLocation:(CLLocationCoordinate2D)coordinate {
	MKReverseGeocoder* reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
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

- (void)findCurrentLocationClicked {
	[self switchToFindingLocationButton];
	
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
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"There was an error %@", error.localizedDescription);
	[self switchToUpdateLocationButton];
	[locationManager stopUpdatingLocation];
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
	NSLog(@"Reverse geocoding failed: error given %@", [error userInfo]);
	selectedAddress = [NSString stringWithFormat:@"%.2f,%.2f", selectedCoordinate.latitude, selectedCoordinate.longitude];
	[self switchToUpdateLocationButton];
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	
	NSMutableString* buffer = [[NSMutableString alloc] initWithCapacity:64];
	if ( placemark.thoroughfare ) {
		[buffer appendString:placemark.thoroughfare];
		[buffer appendString:@" "];
	} 
	if ( placemark.subThoroughfare ) {
		[buffer appendString:placemark.subThoroughfare];
		[buffer appendString:@" "];
	}
	if ( placemark.locality ) {
		[buffer appendString:placemark.locality];
		[buffer appendString:@" "];
	}
	if ( placemark.subLocality ) {
		[buffer appendString:placemark.subLocality];
		[buffer appendString:@" "];
	}
	if ( placemark.administrativeArea ) {
		[buffer appendString:placemark.administrativeArea];
		[buffer appendString:@" "];
	}
	if ( placemark.postalCode ) {
		[buffer appendString:placemark.postalCode];
		[buffer appendString:@" "];
	} 
	if ( placemark.country ) {
		[buffer appendString:placemark.country];
		[buffer appendString:@" "];
	}
	if ( placemark.countryCode ) {
		[buffer appendString:placemark.countryCode];
		[buffer appendString:@" "];
	}
	
	self.selectedAddress = buffer;
	[self addAnnotationAtLocation:self.selectedCoordinate withAddress:buffer];
	[self switchToUpdateLocationButton];
	
	[buffer release];
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
	[toolbar release];
		
    [super dealloc];
}


@end
