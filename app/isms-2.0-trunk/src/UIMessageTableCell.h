//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: UIMessageTableCell.h 251 2008-09-11 13:16:22Z shawn $
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

#ifndef UIMESSAGETABLECELL_H_
#define UIMESSAGETABLECELL_H_

#import "Prefix.h"
#import <UIKit/UIKit.h>
#import <UIKit/UITableColumn.h>
#import "Message.h"
#import <UIKit/UIImageAndTextTableCell.h>

@class UIDateLabel;
/**
 * Customized Cell that display Message information in a table
 * 
 * @Author Shawn
 * 
 */
@interface UIMessageTableCell : UIImageAndTextTableCell
{
	UITextLabel *senderLabel;
	UITextLabel *textLabel;
	UIDateLabel *dateLabel;
	UIImageView	*iconView;
	BOOL		unread;
	BOOL		showMessageDirection;
}
- (id)initWithMessage:(Message*) message;
-(id)initWithMessage:(Message*) message showMessageDirection:(BOOL) value;
//-(BOOL)showMessageDirection;
//-(void)setShowMessageDirection:(BOOL)flag;
@end
#endif /*UIMESSAGETABLECELL_H_*/
