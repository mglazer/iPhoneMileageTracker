//
//  UITableAlert.h
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableAlertDelegate;

@interface UITableAlert : UIAlertView <UITableViewDelegate> {
	id	_tableData;
	id<UITableAlertDelegate> alertDelegate;
@private
	UITableView *table;
}

@property (nonatomic, assign, setter=setTableData:) id tableData;
@property (nonatomic, retain) id<UITableAlertDelegate> alertDelegate;
@end

@protocol UITableAlertDelegate
@required
-(void)tableAlert:(UITableAlert*)tableAlert didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
@end
