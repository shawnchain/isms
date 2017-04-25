//==============================================================================
//	Created on 2007-12-11
//==============================================================================
//	$Id: UIProgressView.h 182 2008-03-13 10:16:18Z shawn $
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
#ifndef UIPROGRESSVIEW_H_
#define UIPROGRESSVIEW_H_

#import <UIKit/UIView.h>
#import <SMSSendStatusCallback.h>

@class UIProgressBar;
@class UITextView;
@class NSMutableArray;
@class NSString;
@class NSArray;
#ifdef __BUILD_FOR_2_0__
@class UIActionSheet;
#else
@class UIAlertSheet;
#endif
@class SMSCenter;

#define PROGRESS_FINISHED_NOTIFICATION @"PROGRESS_FINISHED_NOTIFICATION"

@interface SMSProgressView : UIView <SMSSendStatusCallback>
{
	UIProgressBar	*progressBar;
	UITextView		*statusText;
	
	int				currentState;
	float			progressValue;
#ifdef __BUILD_FOR_2_0__
	UIActionSheet * errorAlert;
#else	
	UIAlertSheet	*errorAlert;
#endif
	
	//SMSCenter		*smsSendController;
}

//-(void)show;
//-(void)showFrom:(UIView*)view;
//-(void)dismiss;
//-(void)setProgress:(float) progress;

-(void)clearAllData;
//-(void)setMessage:(NSString*) msg recipients:(NSArray*)rcpts;

//- (void) fadeIn;
//- (void) fadeOut;
@end

@interface ISMSProgressViewController : UIViewController
{
	
}

@end

#endif /*UIPROGRESSVIEW_H_*/
