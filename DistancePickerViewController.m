//
//  DistancePickerViewController.m
//  MilesTracker
//
//  Created by Mike Glazer on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DistancePickerViewController.h"


@implementation DistancePickerViewController

@synthesize distance, delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#define HUNDREDS_COMPONENT 0
#define TENS_COMPONENT 1
#define ONES_COMPONENT 2
#define DECIMAL_COMPONENT 3
#define TENTHS_COMPONENT 4

- (void)selectDistance {
	float fdist = [distance floatValue];
	
	int hundreds = (int)(fdist / 100.0) % 10;
	int tens = (int)(fdist / 10.0) % 10;
	int ones = (int)(fdist) % 10;
	int tenths = (int)(fdist * 10.0) % 10;
	
	[pickerView selectRow:hundreds inComponent:HUNDREDS_COMPONENT animated:NO];
	[pickerView selectRow:tens inComponent:TENS_COMPONENT animated:NO];
	[pickerView selectRow:ones inComponent:ONES_COMPONENT animated:NO];
	[pickerView selectRow:tenths inComponent:TENTHS_COMPONENT animated:NO];
	
	NSLog(@"%d%d%d.%d - %f", hundreds, tens, ones, tenths, fdist);
}

- (float)getFloatDistance {	
	int hundreds = [pickerView selectedRowInComponent:HUNDREDS_COMPONENT];
	int tens = [pickerView selectedRowInComponent:TENS_COMPONENT];
	int ones = [pickerView selectedRowInComponent:ONES_COMPONENT];
	int tenths = [pickerView selectedRowInComponent:TENTHS_COMPONENT];
	
	return (hundreds * 100.0) + (tens * 10.0) + (ones) + (tenths / 10.0);
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	pickerView.delegate = self;
	pickerView.dataSource = self;
	pickerView.showsSelectionIndicator = YES;
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[self.view addSubview:pickerView];
	
	UIBarButtonItem* acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(accept)];
	self.navigationItem.rightBarButtonItem = acceptButton;
	
	self.navigationItem.title = @"Set Distance";
	
	
	[self selectDistance];
	
	[acceptButton release];
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)accept {
	float fdist = [self getFloatDistance];
	
	[self.delegate didSaveDistance:[NSNumber numberWithFloat:fdist]];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	switch ( component ) {
		case 0:
		case 1:
		case 2:
		case 4:
			return [NSString stringWithFormat:@"%d", row];
		case 3:
			return @".";
	}
	
	return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	CGRect dimensions = [[UIScreen mainScreen] bounds];
	
	CGFloat width = dimensions.size.width;
	CGFloat height = dimensions.size.height;
	
	// decimal point should be 10 pixels, there's 10px on each side, so we have width-30 to divide
	// between the numbers
	
	CGFloat numberWidth = (width - 40)/4;
	
	switch ( component ) {
		case 0:
		case 1:
		case 2:
		case 4:
			return numberWidth;
		case 3:
			return 20;
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	// hundreds, tens, ones, decimal point, tenths
	return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	switch ( component ) {
		case 0:
		case 1:
		case 2:
		case 4:
			return 10;
		case 3:
			return 1;
	}
	
	return 0;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	delegate = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[pickerView release];
}


@end
