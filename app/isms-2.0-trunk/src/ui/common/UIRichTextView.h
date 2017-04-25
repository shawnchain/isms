//==============================================================================
//	Created on 2007-12-14
//==============================================================================
//	$Id: UIRichTextView.h 67 2007-12-14 17:09:05Z shawn $
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
#ifndef UIRICHTEXTVIEW_H_
#define UIRICHTEXTVIEW_H_

#import "Prefix.h"
#import <UIKit/UIKit.h>

@class RichTextParser;
/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface UIRichTextView : UITextView{
	RichTextParser	*parser;
	NSMutableString	*richText;
}

//-(NSString*)richText;
//-(void)setRichText:(NSString*)aString;
//-(NSString*)text;
//-(void)setText:(NSString*)aString;
@end
#endif /*UIRICHTEXTVIEW_H_*/
