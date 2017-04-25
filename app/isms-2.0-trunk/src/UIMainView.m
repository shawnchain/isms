//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: template.txt 11 2007-11-18 05:35:36Z shawn $
//==============================================================================
//	Copyright (C) <2007>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS.
//
//  iSMS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import "Prefix.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UITransitionView.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#else
#import <LayerKit/LayerKit.h>
#import <GraphicsServices/GraphicsServices.h>
#endif

#import "UIMainView.h"
#import "UIMessageMainView.h"
#import "UIMessageSearchView.h"
#import "Log.h"
#import "iSMSApp.h"
#import "UIController.h"

#import "UIMessageView.h"
#import "iSMSPreference.h"
#import "conversation/ISMSConversationView.h"

/**
 * The Main view of iSMS
 * It contains a transitionView as it's main part and a button bar at the bottom
 * 
 * @Author Shawn
 * 
 */
//CGRect defaultClientArea(){
//	return CGRectMake(0,0,320,460 - UI_BOTTOM_BUTTON_BAR_HEIGHT);
//}
#define CURRENT_VERSION @"1.0-rc1-b0414"
#define CURRENT_VERSION_KEY @"__CURRENT_VERSION__"

@implementation UIMainView

+ (UIMainView *) sharedInstance {
	return (UIMainView*)[[iSMSApp getInstance]getViewForName:@"UIMainView"];
}

-(BOOL)isVirgin{
#ifdef DEBUG_ABOUT
	return YES;
#else
	NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_VERSION_KEY];
	if(version){
		//is CURRENT_VERSION
		return ![version isEqual:CURRENT_VERSION];
	}
	return YES;
#endif
}

#ifdef __BUILD_FOR_2_0__
- (UIToolbar *)createButtonBar {
#else
- (UIButtonBar *)createButtonBar {
#endif
	// Create the button bar with default style
	int selectedBarId = 1;
	if([self isVirgin]){
		selectedBarId = 4; // The about
	}
	return [self createButtonBarSetDelegate:self setBarStyle:1 setButtonBarTrackingMode:2 showSelectionForButton:selectedBarId];
}

-(void) transition:(int)style toView:(UIView*) view {
	//currentView = view;
	//[_transitionView transition:style toView:view];
	//UIView* currentView = [[UIController controllerForName:@"main"] currentView];
	// if this is first time customer running, store version number in it and show the about view
	[[UIController controllerForName:@"main"] showView:view withStyle:style];
}

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self == nil) {
		return nil;
	}

	CGRect mainArea = CGRectMake(0,0,320,460 - UI_BOTTOM_BUTTON_BAR_HEIGHT);
	UITransitionView *_transitionView = [[ UITransitionView alloc ] initWithFrame:mainArea];
	[self addSubview: _transitionView ];
	[_transitionView release];

	// Register the child views
	iSMSApp *app = [iSMSApp getInstance];
	[app registerViewForClassName:@"UIMessageMainView" withFrame:mainArea];
	//UIView *msgMainView = [[iSMSApp getInstance] getViewForName:@"UIMessageMainView"];
	LOG(@"msgMainView initialized ok");
	// Other views to be registered
	UIViewController *msgMainViewCtrl = [[ISMSMessageFolderViewController alloc]initWithNibName:nil bundle:nil];
	messageFolderNavCtrl = [[UINavigationController alloc]initWithRootViewController:msgMainViewCtrl];
	[msgMainViewCtrl release];
	
	[app registerViewForClassName:@"UIMessageSearchView" withFrame:mainArea];
	[app registerViewForClassName:@"UIPreferenceView" withFrame:mainArea];
	[app registerViewForClassName:@"UIAboutView" withFrame:mainArea];

	// Register the main controller
	UIController *mainController = [[UIController alloc] initWithTransitionView:_transitionView withDefaultView:messageFolderNavCtrl.view];
	[UIController registerController:mainController forName:@"main"]; // ref +1 = 2
	[mainController release]; // ref -1 = 1
	
	
	[mainController showDefaultViewWithStyle:UITransitionShiftImmediate];
	
	
	// Show the about view if it's first time running
	if([self isVirgin]){
		[[NSUserDefaults standardUserDefaults] setObject:CURRENT_VERSION forKey:CURRENT_VERSION_KEY];
		UIView *about = [[iSMSApp getInstance] getViewForName:@"UIAboutView"];
		[mainController switchToView:about from:messageFolderNavCtrl.view withStyle:UITransitionFade];
	}
		
//	else{
//		[mainController showView:msgMainView withStyle:UITransitionShiftImmediate/*UITransitionFade*/];	
//	}
	
	//[self _switchToView:msgMainView];

	return self;
}

-(void)dealloc {
	RELEASE(messageFolderNavCtrl);
	//RELEASE(msgMainView);
	[super dealloc];
}

- (void)_setButtonFrame:(UIView*)btnView btnTag:(int)tag {
	//[btnView setFrame:CGRectMake(2.0f + ((tag - 1) * 64.0f), 1.0f, 64.0f, 48.0f)];
	if(tag == 1) {
		[btnView setFrame:CGRectMake(2.0f, 1.0f, 65.0f, 48.0f)];
	} else if(tag == 2) {
		[btnView setFrame:CGRectMake(2.0f + 65.0f + 1.0f, 1.0f, 65.0f, 48.0f)];
	} else if(tag == 3) {
		[btnView setFrame:CGRectMake(320.0f - 65.0f - 2.0f - 1.0f - 65.0f,1.0f,65.0f,48.0f)];
	} else if(tag == 4) {
		[btnView setFrame:CGRectMake(320.0f - 65.0f - 2.0f,1.0f,65.0f,48.0f)];
	} else {
		//NOTHING
	}
}

- (NSArray *)buttonBarItems {
	return [ NSArray arrayWithObjects:
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_sms.png", kUIButtonBarButtonInfo,
	@"button_sms_selected.png", kUIButtonBarButtonSelectedInfo,
	[ NSNumber numberWithInt: 1], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Message",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_search.png", kUIButtonBarButtonInfo,
	@"button_search_selected.png", kUIButtonBarButtonSelectedInfo,
	[ NSNumber numberWithInt: 2], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"Search",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],

	[ NSDictionary dictionaryWithObjectsAndKeys:
		@"buttonBarItemTapped:", kUIButtonBarButtonAction,
		@"button_pref.png", kUIButtonBarButtonInfo,
		@"button_pref_selected.png", kUIButtonBarButtonSelectedInfo,
		[ NSNumber numberWithInt: 3], kUIButtonBarButtonTag,
		self, kUIButtonBarButtonTarget,
		NSLocalizedStringFromTable(@"Prefs",@"iSMS",@""), kUIButtonBarButtonTitle,
		@"0", kUIButtonBarButtonType,
		nil
	]
	,
	[ NSDictionary dictionaryWithObjectsAndKeys:
	@"buttonBarItemTapped:", kUIButtonBarButtonAction,
	@"button_more.png", kUIButtonBarButtonInfo,
	@"button_more_selected.png", kUIButtonBarButtonSelectedInfo,
	[ NSNumber numberWithInt: 4], kUIButtonBarButtonTag,
	self, kUIButtonBarButtonTarget,
	NSLocalizedStringFromTable(@"About",@"iSMS",@""), kUIButtonBarButtonTitle,
	@"0", kUIButtonBarButtonType,
	nil
	],
	/*
	 [ NSDictionary dictionaryWithObjectsAndKeys:
	 @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	 @"button.png", kUIButtonBarButtonInfo,
	 @"button_selected.png", kUIButtonBarButtonSelectedInfo,
	 [ NSNumber numberWithInt: 4], kUIButtonBarButtonTag,
	 self, kUIButtonBarButtonTarget,
	 @"Button4", kUIButtonBarButtonTitle,
	 @"0", kUIButtonBarButtonType,
	 nil
	 ],

	 [ NSDictionary dictionaryWithObjectsAndKeys:
	 @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	 @"button.png", kUIButtonBarButtonInfo,
	 @"button_selected.png", kUIButtonBarButtonSelectedInfo,
	 [ NSNumber numberWithInt: 5], kUIButtonBarButtonTag,
	 self, kUIButtonBarButtonTarget,
	 @"Button5", kUIButtonBarButtonTitle,
	 @"0", kUIButtonBarButtonType,
	 nil
	 ],
	 */
	nil
	];
}

- (void)buttonBarItemTapped:(id) sender {
	int button = [ sender tag ];
	UIController* controller = [UIController controllerForName:@"main"];
	UIView* currentView = [controller currentView];
	switch (button) {
		case 1: {
			if (currentView != messageFolderNavCtrl.view) {
				[controller clearAllState];
				[controller showView:messageFolderNavCtrl.view withStyle:/*UITransitionFade*/0];
				//[controller showDefaultViewWithStyle:UITransitionFade];
			}
			break;
		}
		case 2: {
			UIView* view = [[iSMSApp getInstance] getViewForName:@"UIMessageSearchView"];
			if (currentView != view) {
				[controller clearAllState];
				[controller showView:view withStyle:/*UITransitionFade*/0];
				//[self _switchToView:view];
			}
			break;
		}
		case 3: {
			UIView* pView = [[iSMSApp getInstance] getViewForName:@"UIPreferenceView"];
			if (currentView != pView) {
				//[self _switchToView:aboutView];
				[controller clearAllState];
				[controller showView:pView withStyle:/*UITransitionFade*/0];
			}
			break;
		}
		case 4: {
			UIView* aboutView = [[iSMSApp getInstance] getViewForName:@"UIAboutView"];
			if (currentView != aboutView) {
				//[self _switchToView:aboutView];
				[controller clearAllState];
				[controller showView:aboutView withStyle:/*UITransitionFade*/0];
			}
			break;
		}
	}
}

//- (UITransitionView*)getTransitionView {
//	return _transitionView;
//}

// Delegate to the underlying view
-(BOOL)willShow:(NSDictionary*) param {
	LOG(@"UIMainView - willShow()");
	// UIView* currentView = [[UIController controllerForName:@"main"] currentView];
	id currentView = [[UIController controllerForName:@"main"] currentView];
	if(currentView && [currentView respondsToSelector:@selector(willShow:)]) {
		return [currentView willShow:param];
	}
	return YES;
}

-(void)didShow:(NSDictionary*) param {
	// UIView* currentView = [[UIController controllerForName:@"main"] currentView];
	id currentView = [[UIController controllerForName:@"main"] currentView];
	if(currentView && [currentView respondsToSelector:@selector(didShow:)]) {
		[currentView didShow:param];
	}
}

-(BOOL)willHide:(NSDictionary*) param {
	LOG(@"UIMainView - willHide()");
	// UIView* currentView = [[UIController controllerForName:@"main"] currentView];
	id currentView = [[UIController controllerForName:@"main"] currentView];
	if(currentView && [currentView respondsToSelector:@selector(willHide:)]) {
		return [currentView willHide:param];
	}
	return YES;
}

-(void)didHide:(NSDictionary*) param {
	// UIView* currentView = [[UIController controllerForName:@"main"] currentView];
	id currentView = [[UIController controllerForName:@"main"] currentView];
	if(currentView && [currentView respondsToSelector:@selector(didHide:)]) {
		[currentView didHide:param];
	}
}

@end
