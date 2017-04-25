//
//  iSMSAppDelegate.m
//  iSMS
//
//  Created by Shawn Chain on 08-9-11.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iSMSAppDelegate.h"

@implementation iSMSAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
