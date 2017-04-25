//==============================================================================
//	Created on 2007-12-11
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

#import "SMSProgressView.h"
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIProgressBar.h>
#import "iSMSApp.h"
#import "UIMainView.h"

#import <UIKit/UINavigationItem.h>
#import <UIKit/UITransitionView.h>

#import <UIKit/UIAnimator.h>
#import <UIKit/UIAnimation.h>
#import <UIKit/UIAlphaAnimation.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UIHardware.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Deprecated.h>
#import <UIKit/UIActionSheet.h>
#import <UIKit/UIActionSheet-Private.h>
#endif

#import "SMSCenter.h"
#import <MessageUI/SMSComposeRecipient.h>
#import "Message.h"
#import "SMSSendStatusCallback.h"

@implementation SMSProgressView

+(SMSProgressView*) sharedInstance {
	return (SMSProgressView*)[[iSMSApp getInstance]getViewForName:@"SMSProgressView"];
}

-(id)initWithFrame:(CGRect) frame {
	
	// We'll take the full screen
	//struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	//rect.origin.x = 0;
	//rect.origin.y = 0;
	self = [super initWithFrame:frame];
	if(self == nil) {
		return nil;
	}

	float translucentBlack[4] = {0, 0, 0, .7};
	float transparent[4] = {0, 0, 0, 0};
	float white[4] = {1, 1, 1, 1};

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGColorRef translucentBlackColor =  CGColorCreate(colorSpace, translucentBlack);
	CGColorRef transparentColor =  CGColorCreate(colorSpace, transparent);
	CGColorRef whiteColor =  CGColorCreate(colorSpace, white);

#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:translucentBlackColor]];
#else
	[self setBackgroundColor:translucentBlackColor];
#endif

	statusText = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 220.0f, frame.size.width, 200)];
	NSString* prompt = [NSString stringWithFormat:@"<center><strong>%@</strong></center>",NSLocalizedStringFromTable(@"Sending...",@"iSMS",@"")];
#ifdef __BUILD_FOR_2_0__
	[statusText setContentToHTMLString:prompt];
	[statusText setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
	[statusText setTextColor:[UIColor colorWithCGColor:whiteColor]];
	[statusText setFont:[UIFont systemFontOfSize:18.0f]];
#else
	[statusText setHTML:prompt];
	[statusText setBackgroundColor:transparentColor];
	[statusText setTextColor:whiteColor];
	[statusText setTextSize: 18.0f];
#endif
	[statusText setOpaque: YES];
	[self addSubview: statusText];

	/*
	 struct CGRect navrect = CGRectMake(0.0f, 0.0f, 320.0f, 45.0f);
	 navrect.origin.y = rect.size.height - navrect.size.height;
	 
	 UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame: navrect];
	 [navBar setDelegate: self];
	 [navBar setBarStyle:1];
	 [navBar showLeftButton:nil withStyle:1 rightButton:@"Cancel" withStyle:1];
	 UINavigationItem* navtitle = [[UINavigationItem alloc] initWithTitle:@"Sending"];
	 [navBar pushNavigationItem: navtitle];
	 [self addSubview: navBar];
	 [navtitle release];
	 [navBar release];
	 */

	// initialize the progress bar
	struct CGRect irect = CGRectMake(60.0f, 200.0f, 200.0f, 45.0f);
	progressBar = [[UIProgressBar alloc] initWithFrame: irect];
	[progressBar setStyle: 0];
	[progressBar setProgress: 0.];
	[self addSubview: progressBar];
	progressValue = 0.f;
	
	// We need to register to receive notification from the backend thread
	// only support one backend thread currently
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_taskUpdate:) name:SMS_STATUS_NOTIFICATION object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_statusUpdate:) name:SMS_STATUS_NOTIFICATION object:nil];
	
	currentState = READY;
	//currentMessageId = -1; // No message
	
	return self;
}

/*
- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button {
	if(button == 0) {
		currentState = SEND_ABORTED;
		[self fadeOut];
		//FIXME Notify the SMSCenter to cancel the sms sending
		return;
	}
}
*/

//=============================================================================
- (void) _updateProgressIndicator {
	float step = 0.01f;
	if(progressValue > 0.5f){
		//step = 0.01f * (((1- progressValue) / 0.25f));
		step = 0.01f * pow(0.5f,(0.5f /(1- progressValue)));
	}

	progressValue += step;
	if(progressValue > 1.){
		progressValue = 1.;
	}
#ifdef DEBUG_PROGRESS_VIEW
	DBG(@"Step is %f",step);
	DBG(@"Progress %f",progressValue);
#endif
	[progressBar setProgress: progressValue];
}

-(void)_setProgress:(float) f{
	progressValue = f;
	[progressBar setProgress: progressValue];
}

-(void)_alertError{
	if(errorAlert == nil){
		NSArray *buttons = [NSArray arrayWithObjects:
			NSLocalizedStringFromTable(@"Retry",@"iSMS",@""), 
			NSLocalizedStringFromTable(@"Abort",@"iSMS",@""),
			NSLocalizedStringFromTable(@"Abort All",@"iSMS",@""),
			nil];
		NSString* err = [NSString stringWithFormat:@"Error sending message to %@",[[[[SMSCenter getInstance] currentTask] currentRecipient] displayString]];
#ifdef __BUILD_FOR_2_0__
		errorAlert = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		[errorAlert addButtonWithTitle:[buttons objectAtIndex:0]];
		[errorAlert addButtonWithTitle:[buttons objectAtIndex:1]];
		[errorAlert addButtonWithTitle:[buttons objectAtIndex:2]];
		[errorAlert setMessage:err];
	}
	// Prompt user for retry|skip|abort send
	[errorAlert showInView:self];
#else
		errorAlert = [[UIAlertSheet alloc] initWithTitle:@"" buttons:buttons defaultButtonIndex:0 delegate:self context:nil];
		[errorAlert setBodyText:err];
	}
	// Prompt user for retry|skip|abort send
	[errorAlert popupAlertAnimated:YES];
#endif
}

- (void) _progressTimer: (NSTimer*)timer {
	//DBG(@">>> _progressTimer currentState = %d",currentState);
	switch(currentState) {
		case SEND_STARTED:{
			//No need for time-out check because the CoreTelephony should gurantee that the sendStatusCallback will be called.
			[self _updateProgressIndicator];
			// fire up the timer again
			[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(_progressTimer:) userInfo:nil repeats:NO];
			break;
		}
		case SEND_SUCCESS:{
			// Complete the progress bar
			[self _setProgress:1.];
			currentState = READY;
			break;
		}
		case SEND_ERROR:{
			[self _setProgress:0.];
			currentState = READY;
			
			[self _alertError];
			break;
		}
		default:{
			// Others, do nothing
			return;	
		}
	}
}

//========================================================
// Callback methods for SMSCenter status update 
//========================================================
-(void)willSend:(id)data{
	DBG(@">>> willSend %@",data);
	//TODO get the recipient from notify data to support concurrent/true bulk send
	SMSComposeRecipient *rcpt = [data objectForKey:@"recipient"];
	// update the label "Sending to ...
	NSString* prompt = [NSString stringWithFormat:@"<center><strong>%@ %@...</strong></center>",NSLocalizedStringFromTable(@"Sending to",@"iSMS",@""),[rcpt displayString]];
#ifdef __BUILD_FOR_2_0__
	[statusText setContentToHTMLString:prompt];
#else
	[statusText setHTML:prompt];
#endif
	[self _setProgress:0.];
	currentState = SEND_STARTED;
	// Fireup the progress timer
	[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(_progressTimer:) userInfo:nil repeats:NO];
}

-(void)sendSuccess:(id)data{
	DBG(@">>> sendSuccess %@",data);
	currentState = SEND_SUCCESS;
}

-(void)sendError:(id)data{
	DBG(@">>> sendError %@",data);
	currentState = SEND_ERROR;
}

-(void)taskFinished:(id)data{
	// Notify out for the 
	DBG(@">>> taskFinished %@",data);
	[[NSNotificationCenter defaultCenter] postNotificationName:PROGRESS_FINISHED_NOTIFICATION object:self userInfo:data];
}

#ifdef __BUILD_FOR_2_0__
-(void) actionSheet:(UIActionSheet*)sheet clickedWithButtonIndex:(NSInteger)button
{
        [sheet dismissWithClickedButtonIndex:button animated:YES];
#else
-(void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
#endif
	if(sheet == errorAlert){
		switch(button){		
		case 1: // use want to retry
			if(![[SMSCenter getInstance] retry]){
				[self _alertError];
			}
			break;
		case 2: // user want to abort sending to current recipients
			if(![[SMSCenter getInstance] abort]){
				LOG(@"ERROR - Could not abort current recipient!");
				//[self _alertError];
			}
			break;
		case 3: // user want to abort sending to all left recipients
			if(![[SMSCenter getInstance] abortSendTask]){
				// Finish task forcely
				//[[SMSCenter getInstance]finishSendTask];
				//[self _alertError];
				LOG(@"ERROR - Could not abort all send task");
			}
			break;
		}
	}
}

// Only called when fade-in
- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	// Animation done, start send
	DBG(@">>> Animation done, start sending...");
	[[SMSCenter getInstance] send];
}

/*
- (void) fadeIn{
	[self setAlpha: 0.0f];
	UIAlphaAnimation* alpha = [[UIAlphaAnimation alloc] initWithTarget: self];
	[alpha setStartAlpha: 0.0f];
	[alpha setEndAlpha: 1.0f];
	[alpha setDelegate:self];
	
	[[UIAnimator sharedAnimator] addAnimation:alpha withDuration:0.5f start:YES];
	[alpha release];
	[self setEnabled: YES];
}


- (void) fadeOut {
	[self setEnabled: NO];
	UIAlphaAnimation* alpha = [[UIAlphaAnimation alloc] initWithTarget: self];
	[alpha setStartAlpha: 1.0f];
	[alpha setEndAlpha: 0.0f];
	[[UIAnimator sharedAnimator] addAnimation:alpha withDuration:0.5f start:YES];
	[alpha release];
	//[self removeFromSuperview];
}
*/

-(void)clearAllData{
	currentState = READY;
#ifdef __BUILD_FOR_2_0__
	[statusText setContentToHTMLString:@""];
#else
	[statusText setHTML:@""];
#endif
	[statusText setText:@""];
	[self _setProgress:0.];
	// Arbitrary logic to finish current sending task
	if([[SMSCenter getInstance] currentTask]){
		[[SMSCenter getInstance] finishSendTask];	
	}
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	RELEASE(progressBar);
	RELEASE(statusText);
	
	RELEASE(errorAlert);
	[super dealloc];
}

/**
 * Hide and remove from parent view
 */
/*
-(void)dismiss {
	[self clearAllData];
	[self fadeOut];
}
*/
@end

@implementation ISMSProgressViewController
	- (void)loadView {
		UIView *view = [[SMSProgressView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
		//[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];  
		self.view = view;
	}
	
	- (void)viewWillAppear:(BOOL)animated {
		DBG(@"viewWillAppear called - view: %@, animated: %d",self,animated);
		[[SMSCenter getInstance] send];
		/*
		if(animated){

		}
		*/
	}
	
	- (void)viewWillDisappear:(BOOL)animated{
		[self.view clearAllData];
	}
	
@end