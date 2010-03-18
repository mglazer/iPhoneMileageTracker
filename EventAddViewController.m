//
//  EventAddViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventAddViewController.h"
#import "Event.h"

@implementation EventAddViewController

@synthesize event;
@synthesize nameTextField;
@synthesize delegate;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Add Event";
	
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	
	UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButtonItem;
	
	[nameTextField becomeFirstResponder];
	
	[saveButtonItem release];
	[cancelButtonItem release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if ( textField == nameTextField ) {
		[nameTextField resignFirstResponder];
		[self save];
	}
	
	return YES;
}

- (void)save {
	event.name = nameTextField.text;
	
	NSError* error;
	if ( ![event.managedObjectContext save:&error] ) {
		// TODO: Replace with better error handling code
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		abort();
	}
	
	NSLog(@"Sending to delegate");
	[self.delegate eventAddViewController:self didAddEvent:event];
}

- (void)cancel {
	
	[event.managedObjectContext deleteObject:event];
	
	NSError* error;
	if ( ![event.managedObjectContext save:&error] ) {
		// TODO: Replace with better error handling code
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		abort();
	}
	
	[self.delegate eventAddViewController:self didAddEvent:nil];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.nameTextField = nil;
}


- (void)dealloc {
	[event release];
	[nameTextField release];
    [super dealloc];
}


@end
