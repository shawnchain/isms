#import "iSMSApp.h"

#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import "UIController.h"
#import <UIKit/UITransitionView.h>
#import "UIMainView.h"
#import "iSMSPreference.h"
#import "Message.h"
#import "AudioHelper.h"
#import "ObjectContainer.h"
#import "ObjectAdapter.h"
#import "TelephonyHelper.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UIHardware.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#else
#import <LayerKit/LayerKit.h>
#import <GraphicsServices/GraphicsServices.h>
#endif

#import "conversation/ISMSConversationView.h"
#import "UIMessageView.h"


//extern ObjectContainer *container;

/***************************************************************
 * View Class Adapter
 * 
 * @Author Shawn
 ***************************************************************/
@interface ViewAdapter : ObjectAdapter{
	CGRect frame;
}
-(id)initWithClass:(Class)clazz withFrame:(CGRect)rect isSingleton:(BOOL)flag;
-(id)newInstance;
@end
@implementation ViewAdapter
-(id)initWithClass:(Class)clazz withFrame:(CGRect)rect isSingleton:(BOOL)flag{
	self = [super initWithClass:clazz isSingleton:flag];
	if(self == nil){
		return nil;
	}
	frame = rect;
	return self;
}

-(id)newInstance{
	id a = [[objectClass alloc]initWithFrame:frame];
	//LOG(@"View instance %@(0x%x) created",objectClass,a);
	return a;
}
@end

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation iSMSApp

+ (iSMSApp *) getInstance {
#ifdef __BUILD_FOR_2_0__
	return (iSMSApp *)[UIApplication sharedApplication];
#else
	return (iSMSApp *)UIApp;
#endif
}

-(void)_registerViews{
	//Register the UIMainView
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	//CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
	rect.origin.x = rect.origin.y = 0.0f;
	[self registerViewForClassName:@"UIMainView" withFrame:rect];
	[self registerViewForClassName:@"UIComposeSMSView" withFrame:rect];
	[self registerViewForClassName:@"UIMessageView" withFrame:rect];
	[self registerViewForClassName:@"ISMSConversationView" withFrame:rect];
	
//	// The new tab bar controller
//	tabBarController = [[UITabBarController alloc] init];
//	UIViewController *mainViewCtrl = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//	mainViewCtrl.view = [self getViewForName:@"UIMainView"];
//	UINavigationController *folderNavCtrl = 
}

//============================================
// Call back methods 
//============================================
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	willTerminate = NO;
	lastUnreadMsgCount = 0;
	messageChanged = NO;
		
	[self _registerViews];


	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;

	window = [[UIWindow alloc] initWithContentRect: rect];
	transitionView = [[UITransitionView alloc] initWithFrame: rect];
	LOG(@"Loading UIMainView");
	UIView* mainView = [self getViewForName:@"UIMainView"];
	// Initialize the default controller
	UIController *rootViewController = [UIController initDefaultControllerWithTransitionView:transitionView withDefaultView:mainView];
		
	// Check whether last time user quit with conversation view opened
	[self _updateBadgeAndStatusBar:YES];
	
	[[TelephonyHelper sharedInstance] registerSMSReceivedNotification];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	//[NSThread detachNewThreadSelector:@selector(_threadEntry:) toTarget:self withObject:nil];

	iSMSPreference *pref = [iSMSPreference sharedInstance];
	if([[pref lastConversationPhoneNumber] length] > 0){
		NSString *p = [pref lastConversationPhoneNumber];
		DBG(@"!!! Last conversation phone number is: %@",p);
		//[ setLastConversationPhoneNumber:p];
		//[self performSelector:@selector(_showConversationWithPhoneNumber:) withObject:p afterDelay:0];
		[self _showConversationWithPhoneNumber:p];
	}else if([Message countUnreadMessages] > 0){
		//[self performSelector:@selector(_showUnreadMessages) withObject:nil afterDelay:0];
		[self _showUnreadMessages];
	}else{
		[rootViewController showDefaultViewWithStyle:0/*showView:mainView*/];
	}
	
	[window orderFront: self];
	[window makeKey: self];

#ifdef __BUILD_FOR_2_0__
	[window setHidden: NO];
#else
	[window _setHidden: NO];
#endif

	[window setContentView: transitionView];
	
	[window makeKeyAndVisible];
}


-(void)_showConversationWithPhoneNumber:(NSString*)aNumber{
	ISMSConversationView *convView = (ISMSConversationView*)[[iSMSApp getInstance] getViewForName:@"ISMSConversationView"];
	[convView setConversationPhoneNumber:aNumber];
	[[UIController defaultController] switchToView:convView from:nil withStyle:UITransitionShiftLeft];
	
	iSMSPreference *pref = [iSMSPreference sharedInstance];
	[pref setLastConversationPhoneNumber:@""];
	[pref flush];
}

-(void)_showUnreadMessages{ 
	UIMessageView *msgView = [UIMessageView sharedInstance];
	if(msgView){
		NSArray* _l = [Message listUnreadMessages];
		if(_l && [_l count] > 0){
			[msgView resetAllState];
			[msgView setMessageList:_l];
			[msgView setCurrentMessageIndex:0];
			[[UIController defaultController] switchToView:msgView from:nil withStyle:UITransitionShiftLeft];			
		}
	}
}

- (void)applicationWillTerminate {
	//TODO save incomplete message to draft folder ?
	willTerminate = YES;
	// Update the icon badge and the status image again
	//[self _checkUnreadMessages:YES];
	[self _updateBadgeAndStatusBar:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_RECEIVED_NOTIFICATION object:nil];
	[[TelephonyHelper sharedInstance] unregisterSMSReceivedNotification];
	
	// Check whether we're in conversation mode, if yes, store it.
	UIView *currentView = [[UIController defaultController] currentView];
	if([currentView isKindOfClass:[ISMSConversationView class]]){
		ISMSConversationView *convView = (ISMSConversationView*)currentView;
		NSString *p = [convView conversationPhoneNumber];
		DBG(@"Saving conversation with: %@",p);
		[[iSMSPreference sharedInstance] setLastConversationPhoneNumber:p];
	}
	
	LOG(@">>> applicationWillTerminate");
	[super applicationWillTerminate];
}

- (void)applicationResume:(struct __GSEvent*)event{
	LOG(@">>> applicationResume");
	[super applicationResume:event];
}

- (void)applicationDidResume {
	LOG(@">>> applicationDidResume");
	[super applicationDidResume];
	
	[[[UIController defaultController] currentView] setNeedsDisplay];
	
	// Reload data ?
	// FIXME detect change delta and notify out only when data really changed
	id _notifyType = [NSNumber numberWithInt:4];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			_notifyType,@"type",
			nil];
	if(messageChanged){
		messageChanged = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHANGE_NOTIFICATION object:self userInfo:userInfo];
		[[UIController defaultController] refreshCurrentView];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:APP_RESUMED object:self userInfo:nil];	
}

// Called when Home button is pressed or a call comes in
- (void)applicationWillSuspend{
	LOG(@">>> applicationWillSuspend");
	[super applicationWillSuspend];
}

-(void) _messageChanged:(NSNotification*)aNotify{
	//int changeType = [(NSNumber*)[aNotify userInfo] intValue];
	NSDictionary *userInfo = [aNotify userInfo];
	int changeType = [(NSNumber*)[userInfo objectForKey:@"type"] intValue];
	if(changeType == MESSAGE_RECEIVED){
		[self _updateBadgeAndStatusBar:NO];
		if([self isSuspended]){
			messageChanged = YES;
		}else{
			playMessageReceivedSound();
			[[UIController defaultController] refreshCurrentView];
		}
	}else if(changeType == MESSAGE_UPDATED || changeType == MESSAGE_DELETED){
		[self _updateBadgeAndStatusBar:NO];
	}
}

-(void) _updateBadgeAndStatusBar:(BOOL) forceUpdate{
	int unreadCount = CTSMSMessageGetUnreadCount();
	DBG(@"unread message count is %d",unreadCount);
	if(unreadCount > 0){
		if(forceUpdate || lastUnreadMsgCount != unreadCount){
			lastUnreadMsgCount = unreadCount;
			messageChanged = YES;
			// Update the number on the icon and Display the envelope in the statusbar
			[self setApplicationBadge:[NSString stringWithFormat: @"%u", unreadCount]];
			[self addStatusBarImageNamed:@"iSMS" removeOnAbnormalExit:YES];			
		}
	}else{
		if(forceUpdate || lastUnreadMsgCount > 0){
			[self removeStatusBarImageNamed: @"iSMS"];
			[self removeApplicationBadge];
			lastUnreadMsgCount = 0;
			messageChanged = YES;
		}
	}
}

//-(void) _checkUnreadMessages:(BOOL)forceFlag{
//	@synchronized(self){
//		int unreadCount = [Message countByType:UNREAD_MESSAGE];
//		LOG(@"Last unread %d, Current unread %d",lastUnreadMsgCount,unreadCount);
//		
//		if(unreadCount > 0){
//			if(forceFlag || lastUnreadMsgCount != unreadCount){
//				lastUnreadMsgCount = unreadCount;
//				// Show the badge
//				messageChanged = YES;
//				[self setApplicationBadge:[NSString stringWithFormat: @"%u", lastUnreadMsgCount]];
//				// Display the envelope in the statusbar
//				[self addStatusBarImageNamed:@"iSMS" removeOnAbnormalExit:YES];
//			}
//		}else{
//			if(forceFlag || lastUnreadMsgCount > 0){
//				lastUnreadMsgCount = 0;
//				messageChanged = YES;
//				// Remove the envelope in status bar
//				[self removeStatusBarImageNamed: @"iSMS"];
//				[self removeApplicationBadge];
//			}
//		}	
//	}
//}

//- (void) _threadEntry:(id) arg {
//	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
//	
//	LOG(@"watch-dog thread - started");
//	// Sleep 5 seconds and popup a dialog ?
//	while(!willTerminate){
//		NSTimeInterval itv = 15;
//		[NSThread sleepForTimeInterval:itv];
//		NSString* status = ([self isSuspended])?@"Suspended":@"Activated";
//		[self _checkUnreadMessages:NO];
//	}
//	LOG(@"watch-dog thread - exit");
//	[p release];
//}

//- (BOOL)applicationIsReadyToSuspend {
//	return NO;
//}

- (void)applicationSuspend:(struct __GSEvent *)event {
	LOG(@">>> applicationSuspend - %@",event);
	// Suspend is deprecated now
	//if(![[iSMSPreference sharedInstance]runBackground]){
		[super applicationSuspend:event];
	//}
}

- (void)applicationWillSuspendUnderLock {
	LOG(@">>> applicationWillSuspendUnderLock");
	[super applicationWillSuspendUnderLock];
}

- (void)applicationWillSuspendForEventsOnly {
	LOG(@">>> applicationWillSuspendForEventsOnly");
	[super applicationWillSuspendForEventsOnly];
}


-(void)dealloc{
	[UIController release];
	RELEASE(tabBarController);
	RELEASE(transitionView);
	RELEASE(window);
	[super dealloc];
}

//static float x=0.f,y=0.f,z=0.f;
- (void) updateAcceleratedInX: ( float)x  Y: ( float)y  Z: ( float)z {
    //LOG(@">>> accel: %f %f %f", fabs(x), fabs(y), fabs(z));
//  if(fabs(x) > 0.75f){
    if(x > 0.7f){
    	//[self vibrateForDuration:1];
        LOG(@"!!! Shocked!");
        // Check whether we have unreceived message
        int unreadCount = CTSMSMessageGetUnreadCount();
        if(unreadCount > 0){
        	playMessageReceivedSound2(YES);
        }
    }
}

//============================================
// Helper methods 
-(void)registerViewForClassName:(NSString*)className withFrame:(CGRect) aFrame isSingleton:(BOOL) flag{
	Class c = NSClassFromString(className);
	[self registerView:c withFrame:aFrame forName:className isSingleton:flag];
}

-(void)registerViewForClassName:(NSString*)className withFrame:(CGRect) aFrame {
	[self registerViewForClassName:className withFrame:aFrame isSingleton:YES];
}

-(void)registerView:(Class) viewClass withFrame:(CGRect) aFrame forName:(NSString*) name{
	[self registerView:viewClass withFrame:aFrame forName:name isSingleton:YES];
}

-(void)registerView:(Class) viewClass withFrame:(CGRect) aFrame forName:(NSString*) name isSingleton:(BOOL)flag{
	LOG(@"View %@ - %@ registered",name,viewClass);
	ObjectAdapter *adapter = [[ViewAdapter alloc]initWithClass:viewClass withFrame:aFrame isSingleton:flag];
	[[ObjectContainer sharedInstance] registerObjectAdapter:adapter forKey:name];
	[adapter release];
}

-(void)registerViewInstance:(UIView*) aView forName:(NSString*) name{
	LOG(@"View %@ - %@(0x%x) registered",name,[aView class],aView);
	[[ObjectContainer sharedInstance] registerObjectInstance:aView forKey:name];
}

-(UIView*)getViewForName:(NSString*)name{
	return [[ObjectContainer sharedInstance] getObjectForKey:name];
}

-(void)switchToViewForName:(NSString*)viewName from:(UIView*)fromView withStyle:(int) aStyle withParam:(NSMutableDictionary*)param{
	return [[UIController defaultController] switchToView:[self getViewForName:viewName] from:fromView withStyle:aStyle withParam:param];
}

-(void)switchToViewForName:(NSString*)viewName from:(UIView*)fromView withStyle:(int) aStyle{
	return [self switchToViewForName:viewName from:fromView withStyle:aStyle withParam:nil];
}
@end
