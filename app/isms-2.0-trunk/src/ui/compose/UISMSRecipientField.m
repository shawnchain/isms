//==============================================================================
//	Created on 2007-12-13
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

#import "Prefix.h"
#import "UISMSRecipientField.h"
#import "UIComposeSMSView.h"
#import "Log.h"


/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UISMSRecipientField

-(id)init{
	self = [super init];
	if(self){
		textChanged = NO;
		recipients = [[NSMutableDictionary alloc]init];//[[NSMutableDictionary dictionary]retain];
	}
	return self;
}

-(id)initWithFrame:(struct CGRect) rect{
	self = [super initWithFrame:rect];
	if(self == nil){
		return nil;
	}
	textChanged = NO;
	recipients = [[NSMutableDictionary alloc]init];//[[NSMutableDictionary dictionary]retain];
	//TODO initialize other views ?
	return self;
}

-(id)initWithFrame:(struct CGRect) rect withDelegate:(id)aDelegate {
	[self initWithFrame:rect];
	[self setDelegate:aDelegate];
        return self;
}

-(void)dealloc{
	RELEASE(recipients);
	[super dealloc];
}

- (NSDictionary*)recipients{
	return recipients;
}

-(void)clearRecipients{
	LOG(@">>> Clear recipients");
	[self setText:@""];
	[recipients removeAllObjects];
}

//!!!!
// Use number as key and name as value
- (void)addRecipient:(NSString*) name withNumber:(NSString*)number shouldNotifyChange:(BOOL)shouldNotifyChange{
	LOG(@">>> Add recipient %@ with number %@",name,number);

	// First check whether contact name already exists
	id existing = [recipients objectForKey:name];
	if(existing){
		LOG(@"Recipient %@ has already been added for number %@!, rejected number:%@",name,existing,number);
		return;
	}
	
	// Update the recipient field
	NSString *s = [self text];
	if(s == nil || [s length] == 0) {
		s = [NSString stringWithFormat:@"%@,",name];
	} else {
		// Check the last char
		//if([s characterAtIndex:([s length] -1)] == ','){
		if([s hasSuffix:@","]){
			s = [s stringByAppendingFormat:@"%@,",name];	
		}else{
			s = [s stringByAppendingFormat:@",%@,",name];
		}
	}
	
	[recipients setObject:number forKey:name];
	if(!recipients){
		LOG(@"!!! ERROR - Recipient map is null!");
	}else{
		LOG(@"%@",recipients);
	}
	
	LOG(@"recipient string is: %@",s);
	[self setText:s];
	
	// FIXME fire the - (void) fieldEditorDidChange:(id)editor ??
	if(shouldNotifyChange){
		[(UIComposeSMSView*)[self delegate] _recipientFieldChanged];	
	}
}

- (void)addRecipient:(NSString*) name withNumber:(NSString*)number{
	return [self addRecipient:name withNumber:number shouldNotifyChange:YES];
}

-(NSString*)rcipientNumberForName:(NSString*)name{
	return [recipients objectForKey:name];
}

//========================================================================
// OVERRIDDEN methods
- (void)fieldEditorDidBecomeFirstResponder: (id) editor{
	[super fieldEditorDidBecomeFirstResponder:editor];
	//[editor loadHTMLString:@"<a href=\"javascript:alert();\">Hello Hell</a>" baseURL:@"file://"];
//	LOG(@"editor is:%@, text:%@",[editor class],[editor text]);
//	LOG(@"editor webview is:%@",[[editor webView] class]);
	
	//[editor loadHTMLString:@"<a href=\"javascript:alert()\">foo</a>" baseURL:nil];
	//[editor setText:@"<a href=\"javascript:alert()\">foo</a>"];
	[(UIComposeSMSView*)[self delegate] _focusChanged:self];
}

-(BOOL)removeSelectedContact{
	// 1. Locate the contact name at current cursor position
	NSRange selection = [self selectionRange];
	int position = selection.location;
	if(position == 0){
		return NO;
	}
	
	NSArray *nameTokens = [[self text] componentsSeparatedByString:@","];
	int pos = 0;
	NSString *selectedName = nil;
	int i = 0;
	int tokenCount = [nameTokens count];
	for(;i < tokenCount;i++){
		NSString *aName = [nameTokens objectAtIndex:i];
		pos += ([aName length] + 1);
		if(position <= pos){
			selectedName = aName;
			break;
		}
	}
	if(selectedName == nil){
		return NO;
	}
	LOG(@"contact name at cursor position %d, :%@",position,selectedName);
	
	// 2. Remove from internal data structure
	if([recipients objectForKey:selectedName]){
		[recipients removeObjectForKey:selectedName];
		NSMutableString* buffer = [[NSMutableString alloc]init];
		for(int j = 0;j < tokenCount;j++){
			if(j == i){
				// skip the deleted one
				continue;
			}
			[buffer appendFormat:@"%@",[nameTokens objectAtIndex:j]];
			if(j < (tokenCount - 1)){
				[buffer appendString:@","];
			}
		}
		[self setText:buffer];
		selection.location = pos - ([selectedName length] +1);
		selection.length = 0;
		[self setSelectionRange:selection];
		[buffer release];
		return YES;
	}
	return NO;
}

- (BOOL)fieldEditor:(id)editor shouldReplaceWithText:(id)text{
	LOG(@"fieldEditor shouldReplaceWithText %@/%@",text,editor);
	if(text == nil || [text length] == 0){
		// We're deleting something!
		if([[self text] length] == 0 && [recipients count] > 0){
			[self clearRecipients];
			return NO;
		}else{
			// else, try to remove the selected contact
			BOOL result = [self removeSelectedContact/*:editor*/];
			if(result){
				// Flag indicates we have changed the text
				// and will return NO in later shouldInsertText call
				textChanged = YES;
				return NO;
			}
		}
	}
	//return [super fieldEditor:editor shouldReplaceWithText:text];
	return NO;
}

- (BOOL)  fieldEditor: ( id)editor  shouldInsertText: ( id)text  replacingRange: ( struct _NSRange)range {
	LOG(@"fieldEditor %@ shouldInsertText:%S, replacingRange:%d,%d",editor,text,range.location,range.length);
	if(textChanged){
		// We have changed the text, so return NO to tell field do not change the text content anymore.
		textChanged = NO;
		return NO;
	}
	return [super fieldEditor:editor shouldInsertText:text replacingRange:range];
}

/*
// Replace the "+" with ";"
- (BOOL)fieldEditor:(id)editor shouldInsertText:(id)text replacingRange:(struct _NSRange)range{
	LOG(@"fieldEditor shouldInsertText %@ replacingRange:%d,%d",text,range.location,range.length);
	return [super fieldEditor:editor shouldInsertText:text replacingRange:range];
}

- (BOOL)webView:(id)wView shouldInsertText:(id)text replacingDOMRange:(id)range givenAction:(int)action{
	LOG(@"webView:%@ shouldInsertText:%@ replacingDOMRange:%d givenAtion:%d",wView,text,range,action);
}
*/

- (void) fieldEditorDidChange:(id)editor{
//	LOG(@"fieldEditorDidChange - text: %@",[self text]);
	[super fieldEditorDidChange:editor];
//	
//	int recipientTextLen = [[self text]length];
//	if( recipientTextLen == 0){
//		LOG(@"Will clean up the recipients because current text length is %d",recipientTextLen);
//		[recipients removeAllObjects];
//	}
	//CGSize _s = [editor contentSize];
	//LOG(@"Recipient changed, current content size: %f,%f",_s.width,_s.height);
	[(UIComposeSMSView*)[self delegate] _recipientFieldChanged];
	return;
}

- (void) _clearButtonClicked: (id)control{
	[super _clearButtonClicked:control];
	[self clearRecipients];
	//notify the compose view to update the send button state
	[(UIComposeSMSView*)[self delegate] _recipientFieldChanged];
}
@end
