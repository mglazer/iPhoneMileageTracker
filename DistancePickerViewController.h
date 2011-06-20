//
//  DistancePickerViewController.h
//  MilesTracker
//
//  Created by Mike Glazer on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DistancePickerViewControllerDelegate;

@interface DistancePickerViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource> {
	UIPickerView* pickerView;
	NSNumber* distance;
	id<DistancePickerViewControllerDelegate> delegate;
}

@property (nonatomic,copy) NSNumber* distance;
@property (nonatomic,assign) id<DistancePickerViewControllerDelegate> delegate;

@end

@protocol DistancePickerViewControllerDelegate 
-(void) didSaveDistance:(NSNumber*)distance;
@end
