//==============================================================================
//	Created on 2007-12-20
//==============================================================================
//	$Id: UITemplateChooserView.h 267 2008-09-21 14:21:50Z shawn $
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
#ifndef UITEMPLATECHOOSERVIEW_H_
#define UITEMPLATECHOOSERVIEW_H_

#import "Prefix.h"
#import "UIKit/UIView.h"

@class UINavigationBar;
@class UISectionTable;
@class UISectionList;
@class ISMSTemplateEditViewController;

#define TEMPLATE_CHOOSED @"__TEMPLATE_CHOOSED__"
@interface UITemplateChooserView : UIView{
	UINavigationBar	*topBar;
	UISectionTable	*table;
	UISectionList	*list;
//	UIView	*parentView;
	ISMSTemplateEditViewController	*editViewController;
	NSArray	*templateList;
}

//-(void)setShow:(BOOL)flag;
//-(void)setParentView:(UIView*)aView;

- (void)reloadData;
-(void)clearSelection;
@end
#endif /*UITEMPLATECHOOSERVIEW_H_*/

@interface ISMSTemplateChooserViewController : UIViewController
{
	
}


@end

