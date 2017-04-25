//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id: ISMSConversationController.h 191 2008-04-13 09:49:04Z shawn $
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
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
#ifndef ISMSCONVERSATIONCONTROLLER_H_
#define ISMSCONVERSATIONCONTROLLER_H_

#import <Foundation/NSObject.h>

@class UIView;
@interface ISMSConversationController : NSObject{
	UIView			*mainView;
}

+(id)sharedInstance;

-(void)show;
//-(UIView*)mainView;
@end

#endif /*ISMSCONVERSATIONCONTROLLER_H_*/
