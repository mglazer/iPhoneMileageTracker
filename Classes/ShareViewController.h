//
//  ShareViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DatePickerViewController.h"

@class MilesTrackerAppDelegate;

@interface ShareViewController : UITableViewController<MFMailComposeViewControllerDelegate,DatePickerViewControllerDelegate> {
	UITableViewCell* nibLoadedCell;
	
	bool canSendEmail_;
	
	NSDate* startDate_;
	NSDate* endDate_;
	NSString* format_;
	
	bool editingStartDate_;
	
	MilesTrackerAppDelegate* appDelegate;
	
	UILabel* footerView;
}

@property (nonatomic,retain) IBOutlet UITableViewCell* nibLoadedCell;
@property (nonatomic,assign) IBOutlet MilesTrackerAppDelegate* appDelegate;
@property (readonly) NSManagedObjectContext* managedObjectContext;


@end
