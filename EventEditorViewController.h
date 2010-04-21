//
//  EventEditorViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationSelectionViewController.h"

@class Event;

@interface EventEditorViewController : UITableViewController <LocationSelectionViewDelegate> {
	Event* event;
	BOOL editingStartLocation;
//	UINavigationController* navigationController;
}

@property (nonatomic,retain) Event* event;
@property BOOL editingStartLocation;
//@property (nonatomic,retain) UINavigationController* navigationController;

- (UITableViewCell*)cellForDistanceSection:(UITableViewCell*)cell withRow:(NSUInteger)row;
- (UITableViewCell*)cellForNameSection:(UITableViewCell*)cell withRow:(NSUInteger)row;
- (UITableViewCell*)cellForDateSection:(UITableViewCell*)cell withRow:(NSUInteger)row;

- (void)didSelectRowInDateSection:(NSUInteger)row;
- (void)didSelectRowInDistanceSection:(NSUInteger)row;
- (void)didSelectRowInNameSection:(NSUInteger)row;

- (void)save;
- (void)cancel;

- (NSDateFormatter*)createDateFormatter;

@end
