//
//  UITableAlertDataSource.h
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UITableAlertDataSource : NSObject <UITableViewDataSource> {
	NSMutableArray *_data;
}

@property (nonatomic, retain) NSMutableArray *data;

@end
