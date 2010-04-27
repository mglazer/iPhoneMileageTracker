//
//  DatePickerViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController

@synthesize datePicker, delegate, date;

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

	// Set the striped background
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered	target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	UIBarButtonItem* acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(accept)];
	self.navigationItem.rightBarButtonItem = acceptButton;
	
	
	datePicker.date = date;
	
	[cancelButton release];
	[acceptButton release];
	

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void) accept {
	[self.delegate datePickerAcceptedDateSelection:datePicker.date];
}

- (void) cancel {
	[self.delegate datePickerCancelDateSelection];
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
	
	datePicker = nil;
}


- (void)dealloc {
    [super dealloc];

	[datePicker release];
}


@end
