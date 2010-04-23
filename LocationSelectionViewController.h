//
//  LocationSelectionViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BSForwardGeocoder.h"
#import "UItableAlert.h"


@class CLLocation;

@protocol LocationSelectionViewDelegate;
@protocol CLLocationManagerDelegate;

@class BSForwardGeocoder;
@class EventLocationMapAnnotation;

@interface LocationSelectionViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, BSForwardGeocoderDelegate, UIAlertViewDelegate, UITableAlertDelegate> {
	MKMapView* mapView;
	id<LocationSelectionViewDelegate> delegate;
	CLLocationManager* locationManager;
	BSForwardGeocoder* forwardGeocoder;
	EventLocationMapAnnotation* currentAnnotation;	
	
	NSString* existingAddress;
	CLLocationCoordinate2D existingCoordinate;
	
	CLLocationCoordinate2D selectedCoordinate;
	NSString* selectedAddress;

	UISearchBar*	 addressSearchBar;
	UIBarButtonItem* cancelButton;
	UIBarButtonItem* acceptButton;
	UIBarButtonItem* clearMapEntryButton;
	UIBarButtonItem* cancelMapEntryButton;
	
}

@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) id<LocationSelectionViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UISearchBar* addressSearchBar;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) BSForwardGeocoder* forwardGeocoder;
@property (nonatomic,retain) EventLocationMapAnnotation* currentAnnotation;
@property (nonatomic,retain) NSString* existingAddress;
@property (nonatomic,assign) CLLocationCoordinate2D existingCoordinate;
@property (nonatomic,copy) NSString* selectedAddress;
@property (nonatomic,assign) CLLocationCoordinate2D selectedCoordinate;


- (IBAction)findCurrentLocationClicked;
- (void)accept;
- (void)cancel;
- (void)cancelMapSelect;
- (void)addAnnotationAtLocation:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)address;

@end

@protocol LocationSelectionViewDelegate
- (void)didAcceptLocationSelection:(CLLocationCoordinate2D)coordinate withAddress:(NSString*)name;
- (void)didCancelLocationSelection;
- (bool)isStartingPoint;

@end
