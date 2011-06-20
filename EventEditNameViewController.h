//
//  EventAddViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventNameDelegate;
@class Event;

@interface EventEditNameViewController : UIViewController <UITextFieldDelegate> {
	NSString* name;
	UITextField *nameTextField;
	id <EventNameDelegate> delegate;
	NSString* title;
	NSInteger nextID;
}

@property(nonatomic, copy) NSString* name;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, assign) NSInteger nextID;
@property(nonatomic, retain) IBOutlet UITextField* nameTextField;
@property(nonatomic, retain) id <EventNameDelegate> delegate;


- (void)save;
- (void)cancel;

@end

@protocol EventNameDelegate <NSObject>
- (void)eventEditNameViewController:(EventEditNameViewController*)source didSaveName:(NSString*)name;
@end
