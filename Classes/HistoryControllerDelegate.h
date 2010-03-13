//
//  HistoryControllerDelegate.h
//  MilesTracker
//
//  Created by Mike Glazer on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HistoryControllerDelegate : NSObject {
	
	UINavigationController* navigationController;

}

@property (nonatomic,retain) IBOutlet UINavigationController* navigationController;


@end
