//==============================================================================
//	Created on 2008-1-20
//==============================================================================
//	$Id: UITemplateEditView.h 267 2008-09-21 14:21:50Z shawn $
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
#ifndef UITEMPLATEEDITVIEW_H_
#define UITEMPLATEEDITVIEW_H_

#import <UIKit/UIView.h>

@class UINavigationBar;
@class UITable;
@interface UITemplateEditView : UIView
{
	UINavigationBar *topBar;
	UITable *table;
}

-(void)_setupNavBarButton:(BOOL) isEditMode;
- (void)reloadData;
@end

@interface ISMSTemplateEditViewController : UIViewController
{
	
}

@end

#endif /*UITEMPLATEEDITVIEW_H_*/
