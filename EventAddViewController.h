//
//  EventAddViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventAddDelegate;
@class Event;

@interface EventAddViewController : UIViewController <UITextFieldDelegate> {
	Event* event;
	UITextField *nameTextField;
	id <EventAddDelegate> delegate;
}

@property(nonatomic, retain) Event* event;
@property(nonatomic, retain) IBOutlet UITextField* nameTextField;
@property(nonatomic, retain) id <EventAddDelegate> delegate;

- (void)save;
- (void)cancel;

@end

@protocol EventAddDelegate <NSObject>
- (void)eventAddViewController:(EventAddViewController*)source didAddEvent:(Event*)event;

@end
