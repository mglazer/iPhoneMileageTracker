//
//  TrackViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrackViewController.h"
#import "MilesTracker.h"
#import "MilesTrackerAppDelegate.h"
#import "UnitConverter.h"

#import <RoutingRequest.h>
#import <RouteSummary.h>
#import <JsonRoutingParser.h>


@implementation TrackViewController

enum StartStopState {
	StartStopStateNotStarted,
	StartStopStateStart,
	StartStopStateEnd
};

@synthesize startStopControl, startLocationTextField, endLocationTextField, recordButton, activityIndicator, distanceLabel, appDelegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.startLocationTextField.delegate = self;
	self.endLocationTextField.delegate = self;
	self.recordButton.enabled = NO;
	self.activityIndicator.hidesWhenStopped = YES;
	[activityIndicator stopAnimating];
	
	self.distanceLabel.alpha = 0.0;
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.distanceFilter = 10.0f;
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

	startStopState = StartStopStateNotStarted;
	
	tokenManager = [[MilesTracker sharedInstance] tokenManager];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)updateDistance {
	
	if ( startLocation == nil || endLocation == nil ) {
		NSLog(@"Either start or ending location have not been set");
		return;
	}
		
	RoutingRequest* request = [MilesTracker createRoutingRequest];
	request.delegate = self;
	[request findRoute:startLocation to:endLocation vehicle:@"car" tokenManager:tokenManager];
	
	[request release];
}

- (void)updateLocation {
	[activityIndicator startAnimating];
	[locationManager startUpdatingLocation];
}

- (IBAction)recordButtonClicked {
	
	NSLog(@"Record button clicked!");
	
}

- (IBAction)pressedStartStopButton {
	NSLog(@"Pressed button");
	if ( startStopState == StartStopStateNotStarted ) {
		[self updateLocation];
		self.startStopControl.enabled = NO;
	} else if ( startStopState = StartStopStateStart ) {
		[self updateLocation];
		self.startStopControl.enabled = NO;
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Location Update Error"
													message:[[error userInfo] description]
													delegate:nil 
													cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[activityIndicator stopAnimating];
	startStopControl.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
	[activityIndicator stopAnimating];
	
	if ( startStopState == StartStopStateNotStarted ) {
		startStopState = StartStopStateStart;
		startLocationTextField.text = [NSString stringWithFormat:@"%.2f,%.2f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
		startLocation = [newLocation retain];
	} else if ( startStopState == StartStopStateStart ) {
		startStopState = StartStopStateEnd;
		endLocationTextField.text = [NSString stringWithFormat:@"%.2f,%.2f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
		
		[self updateDistance];
		recordButton.enabled = YES;
		endLocation = [newLocation retain];
	}
	
	[locationManager stopUpdatingLocation];
	startStopControl.enabled = YES;
}


#pragma mark -
#pragma mark ServiceRequestResult

- (void) serviceServerResponse:(NSString *)jsonResponse {
	JsonRoutingParser* parser = [[JsonRoutingParser alloc] init];
	
	if ( [parser responceStatus:jsonResponse] ) {
		RouteSummary* result = [parser routeSummury:jsonResponse];
		
		NSNumber* totalDistance = [NSNumber numberWithFloat:(float)result.totalDistance];
		
		distanceLabel.text = [NSString stringWithFormat:@"%.1f %@",
							  [[appDelegate unitConverter] distanceToLocale:totalDistance],
							   [[appDelegate unitConverter] localeDistanceString]];
		
		[result release];
	}
	
	
	[parser release];
}

- (void) serviceServerError:(NSString *)error {
	NSLog(@"Error: %@", error);
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
    [super dealloc];
	
	[startStopControl release];
	[startLocationTextField release];
	[endLocationTextField release];
	[recordButton release];
	[activityIndicator release];
	[distanceLabel release];
	[locationManager release];
	
	[startLocation release];
	[endLocation release];

}


@end
