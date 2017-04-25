//
//  iSMSAppDelegate.h
//  iSMS
//
//  Created by Shawn Chain on 08-9-11.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iSMSViewController;

@interface iSMSAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

@end

