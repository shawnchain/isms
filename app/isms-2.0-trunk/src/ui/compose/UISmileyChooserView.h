//==============================================================================
//	Created on 2007-12-16
//==============================================================================
//	$Id: UISmileyChooserView.h 266 2008-09-20 13:49:22Z shawn $
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
#ifndef UISMILEYCHOOSERVIEW_H_
#define UISMILEYCHOOSERVIEW_H_

#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UITiledView.h>

#define SMILEY_CHOOSED @"__SmileyChoosed__"


@interface ISMSSmileyChooserViewController : UIViewController{
	UIView	*smileyKeyboard;
}

- (IBAction)onCancel;
@end

#endif /*UISMILEYCHOOSERVIEW_H_*/
