//
//  UITableAlertDataSource.m
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UITableAlertDataSource.h"


@implementation UITableAlertDataSource
@synthesize data = _data;

- (id)initWithArray:(NSMutableArray *)array {
	if (self = [super init]) {
		self.data = [array mutableCopy];
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_data count];	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = [_data objectAtIndex:indexPath.row];			
			break;
		default:
			break;
	}
	
	return cell;
}

@end