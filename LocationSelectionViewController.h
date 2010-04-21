//
//  LocationSelectionViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"

@class CLLocation;

@protocol LocationSelectionViewDelegate;
@protocol CLLocationManagerDelegate;


@class BSForwardGeocoder;

@interface LocationSelectionViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, BSForwardGeocoderDelegate, UIAlertViewDelegate> {
	MKMapView* mapView;
	id<LocationSelectionViewDelegate> delegate;
	CLLocation* currentLocation;
	CLLocationManager* locationManager;
	BSForwardGeocoder* forwardGeocoder;
	
	NSArray* lastResults;
	

	UISearchBar*	 addressSearchBar;
	UIBarButtonItem* cancelButton;
	UIBarButtonItem* acceptButton;
	UIBarButtonItem* clearMapEntryButton;
	UIBarButtonItem* cancelMapEntryButton;
	
}

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) id<LocationSelectionViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UISearchBar* addressSearchBar;
@property (nonatomic,retain) CLLocation* currentLocation;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) BSForwardGeocoder* forwardGeocoder;
@property (nonatomic,retain) NSArray* lastResults;



- (IBAction)findCurrentLocationClicked;
- (void)accept;
- (void)cancel;
- (void)cancelMapSelect;

@end

@protocol LocationSelectionViewDelegate
- (void)didSelectLocation:(NSString*)name withCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)didAcceptLocationSelection;
- (void)didCancelLocationSelection;
@end
