//
//  DatePickerViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController : UIViewController {
	UIDatePicker* datePicker;
	id<DatePickerViewControllerDelegate> delegate;
	NSDate* date;
}

//+(UINavigationController*) initWithNavigationBar:(id<DatePickerViewControllerDelegate>)delegate andDate:(NSDate*)date;

@property (nonatomic,retain) IBOutlet UIDatePicker* datePicker;
@property (readwrite,copy) NSDate* date;
@property (nonatomic,assign) id<DatePickerViewControllerDelegate> delegate;


@end

@protocol DatePickerViewControllerDelegate
-(void) datePickerAcceptedDateSelection:(NSDate*)date;
-(void) datePickerCancelDateSelection;
@end
