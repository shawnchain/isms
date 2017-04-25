//==============================================================================
//	Created on 2007-12-27
//==============================================================================
//	$Id$
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
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "Prefix.h"
#import "UIPreferenceView.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesControlTableCell.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UISwitch.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Deprecated.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIActionSheet.h>
#import <UIKit/UIActionSheet-Private.h>
#import <UIKit/UITextLabel.h>
#else
#import <UIKit/UISwitchControl.h>
#endif

#import "iSMSPreference.h"
#import "Message.h"
#import "UITableEx.h"
#import "UIBlackListView.h"
#import "UIController.h"
#include "Util.h"
#import "SQLiteDB.h"

#define PREF_CHANGED @"PREF_CHANGED"
/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface MyUIPreferencesTable : UIPreferencesTable{
	NSArray* selectableRow;
}
@end

@implementation MyUIPreferencesTable
-(BOOL)	canSelectRow:(int)row{
	UITableCell *cell = [self cellAtRow:row column:0];
	return [cell showDisclosure];
	//TODO return TRUE only when the row is inside the selectableRow array
	//return NO;
}
@end

@interface MyUIPreferencesControlTableCell : UIPreferencesControlTableCell
@end

@implementation MyUIPreferencesControlTableCell
-(void)_controlClicked:(id)ctrl{
	[super _controlClicked:ctrl];
	[[NSNotificationCenter defaultCenter] postNotificationName:PREF_CHANGED object:self userInfo:ctrl];
}
@end


/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIPreferenceView

-(void)loadPreference{
	iSMSPreference* prefs = [iSMSPreference sharedInstance];
	
#ifdef __BUILD_FOR_2_0__
	swConfirmBeforeSend = [[UISwitch alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swConfirmBeforeSend setOn:[prefs confirmBeforeSend]];
#else
	swConfirmBeforeSend = [[UISwitchControl alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swConfirmBeforeSend setValue:[prefs confirmBeforeSend]];
#endif
	
	BOOL _hookReady = [prefs isHelperInstalled];
	BOOL _hookEnabled = [prefs hookEnabled];
#ifdef __BUILD_FOR_2_0__
	swHookEnabled = [[UISwitch alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swHookEnabled setOn:_hookEnabled];
#else
	swHookEnabled = [[UISwitchControl alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swHookEnabled setValue:_hookEnabled];
#endif
	[swHookEnabled setEnabled:_hookReady];
	
#ifdef __BUILD_FOR_2_0__
	swDefaultApp = [[UISwitch alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swDefaultApp setOn:[prefs defaultApp]];
#else
	swDefaultApp = [[UISwitchControl alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swDefaultApp setValue:[prefs defaultApp]];
#endif
	[swDefaultApp setEnabled:_hookReady && _hookEnabled];
		
#ifdef __BUILD_FOR_2_0__
	swUseConversationView = [[UISwitch alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swUseConversationView setOn:[prefs useConversationView]];
#else
	swUseConversationView = [[UISwitchControl alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swUseConversationView setValue:[prefs useConversationView]];
#endif	

#ifdef __BUILD_FOR_2_0__
	swNewMessagePreview = [[UISwitch alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swNewMessagePreview setOn:[prefs newMessagePreview]];
#else
	swNewMessagePreview = [[UISwitchControl alloc] initWithFrame:CGRectMake(200., 10., 50., 20.)];
	[swNewMessagePreview setValue:[prefs newMessagePreview]];
#endif

	[swNewMessagePreview setEnabled:_hookReady && _hookEnabled];
}

-(id)initWithFrame:(struct CGRect)frame {
	self = [super initWithFrame:frame];
	if(self == nil){
		return self;
	}
	
	[self loadPreference];
	//FIXME use passed in frame
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;

	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[navBar enableAnimation];
	[navBar pushNavigationItem: [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Preferences",@"iSMS",@"")]];
	[self addSubview:navBar];
	
	table = [[MyUIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, 320.0f, 415.0f)];
	[table setDataSource:self];
	[table setDelegate:self];
	[table reloadData];

	[self addSubview:table];
	
	// Register listener
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_prefChanged:) name:PREF_CHANGED object:nil];
	return self;
}

-(void)_alertRestart:(id)context{
	if(restartAlert == nil){
		NSArray *buttons = [NSArray arrayWithObjects:
						NSLocalizedStringFromTable(@"Restart Now",@"iSMS",@""), 
						NSLocalizedStringFromTable(@"Restart Later",@"iSMS",@""),
						NSLocalizedStringFromTable(@"Cancel",@"iSMS",@""),
						nil];
		NSString* text = NSLocalizedStringFromTable(@"NEED_RESTART_ALERT",@"iSMS",@"");
#ifdef __BUILD_FOR_2_0__
                restartAlert = [[UIActionSheet alloc] initWithTitle:@"NOTE" delegate:self cancelButtonTitle:[buttons objectAtIndex:2]
                                                      destructiveButtonTitle:[buttons objectAtIndex:0] 
                                                      otherButtonTitles:nil];
                [restartAlert addButtonWithTitle:[buttons objectAtIndex:1]];
                [restartAlert setMessage:text];
        }
	[restartAlert setContext:context];
        [restartAlert showInView:self];
#else
		restartAlert = [[UIAlertSheet alloc] initWithTitle:@"NOTE" buttons:buttons defaultButtonIndex:2 delegate:self context:nil];
		[restartAlert setDestructiveButton:[[restartAlert buttons] objectAtIndex:0]];
	    [restartAlert setBodyText:text];
	}
	[restartAlert setContext:context];
    [restartAlert popupAlertAnimated:YES];
#endif
}

-(void)_prefChanged:(NSNotification*)aNotify{
	id ctrl = [aNotify userInfo];
	if(ctrl == swDefaultApp){
#ifdef __BUILD_FOR_2_0__
		LOG(@"Prefs: defaultApp: %@",[(UISwitch*)ctrl isOn]?@"YES":@"NO");
#else
		LOG(@"Prefs: defaultApp: %@",[(UISwitchControl*)ctrl value]?@"YES":@"NO");
#endif
		[self _alertRestart:ctrl];
	}else if(ctrl == swHookEnabled){
		[self _alertRestart:ctrl];
	}
	[self save];
}

- (void)reloadData
{
	[table reloadData];
}

-(void)save{
	iSMSPreference *prefs = [iSMSPreference sharedInstance];
#ifdef __BUILD_FOR_2_0__
	[prefs setDefaultApp:[swDefaultApp isOn]];
	[prefs setHookEnabled:[swHookEnabled isOn]];
	[prefs setConfirmBeforeSend:[swConfirmBeforeSend isOn]];
	[prefs setUseConversationView:[swUseConversationView isOn]];
	[prefs setNewMessagePreview:[swNewMessagePreview isOn]];
#else
	[prefs setDefaultApp:[swDefaultApp value]];
	[prefs setHookEnabled:[swHookEnabled value]];
	[prefs setConfirmBeforeSend:[swConfirmBeforeSend value]];
	[prefs setUseConversationView:[swUseConversationView value]];
	[prefs setNewMessagePreview:[swNewMessagePreview value]];
#endif
	[prefs flush];
}

#pragma mark ----------------Delegate Methods----------------

- (void)tableRowSelected:(NSNotification *)notification {
	int row = [table selectedRow];
	DBG(@"selected row %d", row);
	switch(row){
	case 7:{
#ifdef __BUILD_FOR_2_0__
		if(!([swHookEnabled isEnabled] && [swHookEnabled isOn])){
#else
		if(!([swHookEnabled isEnabled] && [swHookEnabled value])){
#endif
			[table clearRowSelection];
			//Hook is disabled
			return;
		}
		
		if(blackListView == nil){
			blackListView = [[UIBlackListView alloc]initWithFrame:[self bounds]];
		}
		UIController* controller = [UIController controllerForName:@"main"];
		//UIView* currentView = [controller currentView];
		[controller switchToView:blackListView from:self withStyle:UITransitionShiftLeft];
		break;
	}
	}
}

#pragma mark ---------------Datasource Methods---------------

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
	// 3 groups in total
	return 3;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	// preference items in each group
	if(group == 0){
		// The SEND_CONFIRM group
		return 2;
	}else if(group == 1){
		// The HOOK group
		return 4;
	}else if(group == 2){
		// The description of HOOK group
		return 1;
	}
	return 0;// currently we only have one switch control
}

//- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
//{
//	UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
//
//	return [cell autorelease];
//}

//- (BOOL)preferencesTable:(UIPreferencesTable*)table isLabelGroup:(int)group
//{
//    switch ( group ) {
//        case 0:
//            return NO;
//        case 1:
//            return NO;
//        case 2:
//            return NO;
//	case 3:
//	    return YES;
//
//    }
//    return NO;
//}

- (float)preferencesTable:(UIPreferencesTable *)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
//	return proposed;
  switch (group) {
    case 0:
      return proposed;
    case 1:
      return proposed;
    case 2:
      return proposed;
    case 3:
      return proposed;
    default:
      return proposed;
  }
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForRow:(int)row inGroup:(int)group
{
	BOOL _helperInstalled = [[iSMSPreference sharedInstance] isHelperInstalled];
#ifdef __BUILD_FOR_2_0__
	BOOL _hookEnabled = [swHookEnabled isOn];
#else
	BOOL _hookEnabled = [swHookEnabled value];
#endif
	UIPreferencesControlTableCell *cell = nil; 
	if(group == 0){
		switch(row){
			case 0:{
				cell = [[MyUIPreferencesControlTableCell alloc] init];
				[cell setTitle:NSLocalizedStringFromTable(@"Send Confirmation",@"iSMS",@"")];
				[cell setControl:swConfirmBeforeSend];
				break;
			}case 1:{
				cell = [[MyUIPreferencesControlTableCell alloc] init];
				[cell setTitle:NSLocalizedStringFromTable(@"Enable Conversation",@"iSMS",@"")];
				[cell setControl:swUseConversationView];
				break;
			}
		}
	}else if(group == 1){
		switch(row){
			case 0:
			{
				cell = [[MyUIPreferencesControlTableCell alloc] init];
				[cell setTitle:NSLocalizedStringFromTable(@"Enable SB Helper",@"iSMS",@"")];
				[cell setControl:swHookEnabled];
				[cell setEnabled:_helperInstalled];
				break;
			}
			case 1:
			{
				cell = [[MyUIPreferencesControlTableCell alloc] init];
				//[cell setTitle:NSLocalizedStringFromTable(@"Run Background",@"iSMS",@"")];
				[cell setTitle:NSLocalizedStringFromTable(@"Default SMS App",@"iSMS",@"")];
				[cell setControl:swDefaultApp];
				//[cell setEnabled:[swHookEnabled value]];
#ifdef __BUILD_FOR_2_0__
				[swDefaultApp setEnabled:[swHookEnabled isEnabled] && [swHookEnabled isOn]];
#else
				[swDefaultApp setEnabled:[swHookEnabled isEnabled] && [swHookEnabled value]];
#endif
				[cell setEnabled:_helperInstalled && _hookEnabled];
				break;
			}
			case 2:
			{
				cell = [[MyUIPreferencesControlTableCell alloc] init];
				[cell setTitle:NSLocalizedStringFromTable(@"New Message Preview",@"iSMS",@"")];
				[cell setControl:swNewMessagePreview];
#ifdef __BUILD_FOR_2_0__
				[swNewMessagePreview setEnabled:[swHookEnabled isEnabled] && [swHookEnabled isOn]];
#else
				[swNewMessagePreview setEnabled:[swHookEnabled isEnabled] && [swHookEnabled value]];
#endif
				[cell setEnabled:_helperInstalled && _hookEnabled];
				break;
			}
			case 3:
			{
				cell = [[UIPreferencesTableCell alloc] init];
				[cell setTitle:NSLocalizedStringFromTable(@"SMS Black List",@"iSMS",@"")];
				if(_helperInstalled && _hookEnabled/*[[iSMSPreference sharedInstance] isHelperInstalled]*/){
					[cell setShowDisclosure:YES];
					[cell setDisclosureStyle:1];					
				}else{
					[cell setShowDisclosure:NO];
					[cell setEnabled:NO];
				}
				//[cell setDisclosureClickable:YES];
			}
		}
	}else if(group == 2){
		switch(row){
			case 0:
			{
				// The code to draw the description head
				cell = [[UIPreferencesTableCell alloc] init];
//				[cell setAlignment:4];
				[cell setDrawsBackground: NO];
				//[cell _setDrawAsGroupTitle: YES];
				[cell _setDrawAsLabel:YES];
				[cell setTitle:NSLocalizedStringFromTable(@"ENABLE_SB_HELPER_NOTE",@"iSMS",@"")];
				UITextLabel* l = [cell titleTextLabel];
				[l setWrapsText:YES];
				[l setCentersHorizontally:NO];
				//[l setText:NSLocalizedStringFromTable(@"ENABLE_SB_HELPER_NOTE",@"iSMS",@"")];
				//CGRect rect = [l frame];
				//rect.origin.x -= 5;
				//[l setFrame:rect];
				//[cell layoutSubviews];
				break;
			}
			/*
			case 1:
			{
				// The code to draw the description head
				cell = [[UIPreferencesTableCell alloc] init];
				[cell setAlignment:3];
				[cell setDrawsBackground: NO];
				//[cell _setDrawAsGroupTitle: YES];
				[cell _setDrawAsLabel:YES];
				if(osVersion() < 113){
					[cell setTitle:NSLocalizedStringFromTable(@"AUTO_ARCHIVE_NOTE",@"iSMS",@"")];	
				}else{
					[cell setTitle:@"Auto archive is not necessary for 1.1.3+ FW"];
				}
				UITextLabel* l = [cell titleTextLabel];
				[l setWrapsText:YES];
				[l setCentersHorizontally:NO];
				break;
			}*/
			
		}
		
	}
	
	return [cell autorelease];	
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:PREF_CHANGED object:nil];
	RELEASE(navBar);
	RELEASE(table);
	RELEASE(swConfirmBeforeSend);
	RELEASE(swUseConversationView);
	RELEASE(swHookEnabled);
	RELEASE(swDefaultApp);
	RELEASE(swNewMessagePreview);
	
	RELEASE(restartAlert);
	[super dealloc];
}

-(void)didShow:(NSDictionary*)param{
	[table clearRowSelection];
}

#ifdef __BUILD_FOR_2_0__
-(void) actionSheet:(UIActionSheet *)sheet clikedButtonAtIndex:(NSInteger)button
{
	[sheet dismissWithClickedButtonIndex:button animated:YES];
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
#endif
	id ctx = [sheet context];
	[sheet setContext:nil];
	if(sheet == restartAlert){
		if(ctx == swDefaultApp){
	        if(button == 1){
	        	[self save];
	            springboard_restart();
#ifdef __BUILD_FOR_2_0__
			[[UIApplication sharedApplication] terminate];
#else
	        	[UIApp terminate];
#endif
	            return;
	        }else if(button == 3){
	        	// Revert and exit
#ifdef __BUILD_FOR_2_0__
	        	[swDefaultApp setOn:![swDefaultApp isOn]];
#else
	        	[swDefaultApp setValue:![swDefaultApp value]];
#endif
	        	return;
	        }
		}else if(ctx == swHookEnabled){
	        if(button == 1){
	        	[self save];
	            springboard_restart();
#ifdef __BUILD_FOR_2_0__
     			[[UIApplication sharedApplication] terminate];
#else
	        	[UIApp terminate];
#endif
	            return;
	        }else if(button == 3){
	        	// Revert and exit
#ifdef __BUILD_FOR_2_0__
	        	[swHookEnabled setOn:![swHookEnabled isOn]];
#else
	        	[swHookEnabled setValue:![swHookEnabled value]];
#endif
	        	return;
	        }else{
	        	// Just update the swDefaultApp state according to swHookEnabled value
#ifdef __BUILD_FOR_2_0__
	        	[swDefaultApp setEnabled:[swHookEnabled isOn]];
	        	[swNewMessagePreview setEnabled:[swHookEnabled isOn]];
#else
	        	[swDefaultApp setEnabled:[swHookEnabled value]];
	        	[swNewMessagePreview setEnabled:[swHookEnabled value]];
#endif
	        }
		}
		
		// We're done, refresh the table
		//[table reloadData];
	}
}


#ifdef DEBUG
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL rts = [super respondsToSelector:sel];
  DBG(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
  return rts;
}
#endif

@end
