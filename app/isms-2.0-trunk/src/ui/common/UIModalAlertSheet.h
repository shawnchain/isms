//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIModalAlertSheet.h 251 2008-09-11 13:16:22Z shawn $
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

#ifndef UIMODALALERTSHEET_H_
#define UIMODALALERTSHEET_H_

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIAlertView.h>
#else
#import <UIKit/UIAlertSheet.h>
#endif

/***************************************************************
 * Modal alert sheet
 * 
 * @Author Shawn
 ***************************************************************/
#ifdef __BUILD_FOR_2_0__
@interface UIModalAlertSheet : UIAlertView {
#else
@interface UIModalAlertSheet : UIAlertSheet{
#endif
	@private
	int result;
}
-(id)initWithTitle:(NSString*) title buttons:(NSArray*)buttons defaultButtonIndex:(int)defaultButtonIndex;
-(int)result;
@end
#endif /*UIMODALALERTSHEET_H_*/
