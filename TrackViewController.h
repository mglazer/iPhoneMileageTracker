//
//  TrackViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <ServiceRequest.h>

@class TokenManager;
@class MilesTrackerAppDelegate;

@interface TrackViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate,ServiceRequestResult> {
	UISegmentedControl* startStopControl;
	UITextField* startLocationTextField;
	UITextField* endLocationTextField;
	UIButton* recordButton;
	UIActivityIndicatorView* activityIndicator;
	UILabel* distanceLabel;
	
	CLLocationManager* locationManager;
	
	int startStopState;
	CLLocation* startLocation;
	CLLocation* endLocation;
	TokenManager* tokenManager;
	MilesTrackerAppDelegate* appDelegate;
}

@property (nonatomic,retain) IBOutlet UISegmentedControl* startStopControl;
@property (nonatomic,retain) IBOutlet UITextField* startLocationTextField;
@property (nonatomic,retain) IBOutlet UITextField* endLocationTextField;
@property (nonatomic,retain) IBOutlet UIButton* recordButton;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic,retain) IBOutlet UILabel* distanceLabel;
@property (nonatomic,assign) IBOutlet MilesTrackerAppDelegate* appDelegate;

- (IBAction)recordButtonClicked;
- (IBAction)pressedStartStopButton;

@end
