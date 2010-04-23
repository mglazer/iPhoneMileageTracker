//
//  UITableAlert.m
//  UIAlert-EmbeddedTable
//
//  Created by Skylar Cantu on 10/10/09.
//  Copyright 2009 Skylar Cantu. All rights reserved.
//

#import "UITableAlert.h"


@implementation UITableAlert

@synthesize tableData = _tableData;
@synthesize alertDelegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		table.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
		table.delegate = self;
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, rect.size.width, 310)];
	self.center = CGPointMake(320/2, 480/2);
}


- (void)layoutSubviews {
	CGFloat buttonTop;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIThreePartButton"]) {
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			buttonTop = view.frame.origin.y;
		}
	}
	
	buttonTop -= 7; buttonTop -= 200;
	
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(12, buttonTop, self.frame.size.width - 53, 200)];
	container.backgroundColor = [UIColor whiteColor];
	container.clipsToBounds = YES;
	[self addSubview:container];
	
	table.frame = container.bounds;
	[container addSubview:table];
	
	UIGraphicsBeginImageContext(container.frame.size);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.9, 0.9, 0.9, 1.0);
	CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, -3), 3.0);
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
	UIImageView *imageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
	[container addSubview:imageView];
	[imageView release];
	UIGraphicsEndImageContext();
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}


- (void)dealloc {
	[table release];
    [super dealloc];
}


#pragma mark 
#pragma mark Property Methods

- (void)setMessage:(NSString *)message {
	return;
}

- (NSString *)message {
	return nil;
}

- (void)setTableData:(id)tableData {
	_tableData = tableData;
	table.dataSource = _tableData;	
	[table reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[alertDelegate tableAlert:self didSelectRowAtIndexPath:indexPath];
}


@end
