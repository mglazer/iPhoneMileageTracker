//
//  EventEditorViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventEditorViewController : UITableViewController {
	Event* event;
	UINavigationController* navigationController;
}

@property (nonatomic,retain) Event* event;
@property (nonatomic,retain) UINavigationController* navigationController;

- (UITableViewCell*)cellForDistanceSection:(UITableViewCell*)cell withRow:(NSUInteger)row;
- (UITableViewCell*)cellForNameSection:(UITableViewCell*)cell withRow:(NSUInteger)row;
- (UITableViewCell*)cellForDateSection:(UITableViewCell*)cell withRow:(NSUInteger)row;

- (NSDateFormatter*)createDateFormatter;

@end
