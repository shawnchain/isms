//==============================================================================
//	Created on 2007-12-14
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
#import "UIRichTextView.h"
#import "ui/compose/SmileyManager.h"
#import "Log.h"
typedef enum _parser_state {
	TEXT = 0,
	FORMAT = 1
} PARSER_STATE;

/***************************************************************
 * Node Class
 * 
 * @Author Shawn
 ***************************************************************/
@interface Node : NSObject {
	NSString* text;
	NSString* html;
}
@end

@implementation Node
-(id)init{
	self = [super init];
	text = nil;
	html = nil;
	return self;
}
-(void)setText:(NSString*)aText {
	RETAIN(text,aText);
}
-(void)setHTML:(NSString*)aHTML {
	RETAIN(html,aHTML);
}
-(NSString*)text {
	return text;
}
-(NSString*)html {
	return html;
}
-(void)dealloc{
	RELEASE(text);
	RELEASE(html);
	[super dealloc];
}
@end

/***************************************************************
 * Parser class
 * 
 * @Author Shawn
 ***************************************************************/
@interface RichTextParser : NSObject {
	//NSMutableString* textBuffer;
	NSMutableString* formatBuffer;
	//NSMutableString* rawTextBuffer;
	NSMutableArray* nodeList;
	PARSER_STATE state;
	NSString			*startChars;
	NSString			*stopChars;
	NSDictionary		*emotionMap;
}

-(void)appendChar:(unichar)aChar;
-(id)deleteNodeAtIndex:(int)index;
-(id)nodeAtIndex:(int)index;
-(NSString*)html;
-(NSString*)text;
-(void)reset;

@end

@implementation RichTextParser

-(void)_loadEmotions{
	emotionMap = [[[SmileyManager sharedInstance] allSmileyMap] retain];
	NSArray* keys = [emotionMap allKeys];
	int len = [keys count];
	unichar* starts = malloc(sizeof(unichar) * (len + 1));
	unichar* stops = malloc(sizeof(unichar) * (len + 1));
	for(int i =0;i<len;i++){
		NSString* value = [keys objectAtIndex:i];
		starts[i] = [value characterAtIndex:0];
		stops[i] = [value characterAtIndex:([value length]-1)];
	}
	starts[len] = '\0';
	stops[len] = '\0';
	startChars = [[NSString alloc] initWithCharacters:starts length:len];
	stopChars = [[NSString alloc] initWithCharacters:stops length:len];	
	DBG(@"Start char seq: %@",startChars);
	DBG(@"Staop char seq: %@",stopChars);
	free(starts);
	free(stops);
}

-(id)init {
	self = [super init];
	if(self) {
		state = TEXT;
		formatBuffer = [[NSMutableString alloc] init/*WithCapacity:256*/];
		nodeList = [[NSMutableArray alloc] init];
		
		[self _loadEmotions];
	}
	return self;
}

-(void)dealloc {
	RELEASE(emotionMap);
	RELEASE(startChars);
	RELEASE(stopChars);
	RELEASE(formatBuffer);
	RELEASE(nodeList);
	[super dealloc];
}

// Currently only support :) :-) :-( :| :-|
// start char is :/;
// Stop char is )(|
-(BOOL)_isFormatStart:(unichar)aChar {
	for(int i =0;i<[startChars length];i++){
		if(aChar == [startChars characterAtIndex:i]){
			return YES;
		}
	}
	return NO;
	//return aChar == ':' || aChar == ';';
}

-(BOOL)_isFormatStop:(unichar)aChar {
	//return aChar == ')' || aChar == '(' || aChar == '|';
	for(int i =0;i<[stopChars length];i++){
		if(aChar == [stopChars characterAtIndex:i]){
			return YES;
		}
	}
	return NO;
}

-(BOOL)_isNotCharacter:(unichar)aChar {
	return aChar == '\n' || aChar == '\r' || aChar == '\t';
}

-(void)_clearBuffer:(NSMutableString*)aMutableString {
	NSRange range;
	range.location=0;
	range.length=[aMutableString length];
	[aMutableString deleteCharactersInRange:range];
}

#define ICON_IMG_TEMPLATE @"<img src=\"file:///Applications/iSMS2.app/smileys/default/%@\"/>"
-(NSString*)getFormattedText:(NSString*)aFormat {
	NSString *file = [emotionMap objectForKey:aFormat];
	if(file == nil){
		return aFormat;
	}
	return [NSString stringWithFormat:ICON_IMG_TEMPLATE,file];
}

-(void)addNode:(Node*) node {
	[nodeList addObject:node];
#ifdef DEBUG_RICH_TEXT	
	DBG(@"Node[%d] %@/%@ added",([nodeList count] - 1),[node text], [node html]);
#endif	
}

-(void)addNodeText:(NSString*)text withHTML:(NSString*) html {
	Node* node = [[Node alloc] init];
	[node setText:[NSString stringWithFormat:@"%@",text]];
	[node setHTML:[NSString stringWithFormat:@"%@",html]];
	[self addNode:node];
	[node release];
}

//-(void)addTextChar:(unichar)aChar {
-(void)addTextChar:(unichar)aChar {
	unichar c[2];
	c[0] = aChar;
	c[1] = '\0';
	NSString* text = [[NSString alloc] initWithCharacters:c length:1];//[NSString stringWithFormat:@"%C",aChar];
	NSString* html = text;
	if(aChar == ' ') {
		html = @"&nbsp;";
	}else if(aChar == '\n'){
		html = @"<br/>";
	}else if(aChar == '<'){
		html = @"&lt;";
	}else if(aChar == '>'){
		html = @"&gt;";
	}
	LOG(@"Add text char %@",text);
	//[textBuffer appendString:html];
	[self addNodeText:text withHTML:html];
	[text release];
}

-(void)addTextString:(NSString*)aString {
	for(int i = 0;i<[aString length];i++) {
		[self addTextChar:[aString characterAtIndex:i]];
	}
}

-(void)appendChar:(unichar)aChar {
	unichar _c[2];
	_c[0] = aChar;
	_c[1] = '\0';
	NSString *s = [[NSString alloc]initWithCharacters:_c length:1];
#ifdef DEBUG_RICH_TEXT	
	DBG(@"Got char %@",s);
#endif	
	//[rawTextBuffer appendFormat:@"%C",aChar];
	switch (state) {
		case TEXT: {
			if([self _isFormatStart:aChar]) {
				//[formatBuffer appendFormat:@"%@",c];
				[formatBuffer appendString:s];
				state = FORMAT;
			} else {
				[self addTextChar:aChar];
			}
			break;
		}case FORMAT: {
			// If got start tag or non-char, state to TEXT and the formats should be text
			if([self _isFormatStart:aChar] || [self _isNotCharacter:aChar]) {
				// Invalid format, all previous chars are texts
				//				[textBuffer appendString:formatBuffer];
				//				[textBuffer appendFormat:@"%C",formatBuffer,aChar];
				[self addTextString:formatBuffer];
				[self addTextChar:aChar];
				[self _clearBuffer:formatBuffer];
				//[formatBuffer setString:@""];
				state = TEXT;
			}
			// if got stop, replacement and clean the format buffer
			else if([self _isFormatStop:aChar]) {
				// Format done
				[formatBuffer appendString:s];
				NSString *html = [self getFormattedText:formatBuffer];
				DBG(@"text %@ converted to html %@",formatBuffer,html);
				[self addNodeText:formatBuffer withHTML:html];
				[self _clearBuffer:formatBuffer];
				state = TEXT;
			} else {
				//[formatBuffer appendFormat:@"%C",aChar];
				[formatBuffer appendString:s];
			}
		}
	}
	[s release];
}

-(NSString*)html {
	NSMutableString* result = [[NSMutableString alloc] initWithCapacity:256];
	for(int i = 0;i<[nodeList count];i++) {
		Node* node = [nodeList objectAtIndex:i];
		[result appendFormat:@"%@",[node html]];
	}
	
	if([formatBuffer length] > 0){
		[result appendFormat:@"%@",formatBuffer];	
	}
	return [result autorelease];
}

-(NSString*)text {
	NSMutableString* result = [[NSMutableString alloc] initWithCapacity:256] ;
	for(int i = 0;i<[nodeList count];i++) {
		Node* node = [nodeList objectAtIndex:i];
		[result appendFormat:@"%@", [node text]];
	}
	if([formatBuffer length] > 0){
		[result appendFormat:@"%@", formatBuffer];	
	}
	return [result autorelease];
}

-(void)reset {
	state = TEXT;
	//[textBuffer setString:@""];
	[formatBuffer setString:@""];
	//[rawTextBuffer setString:@""];
	[nodeList removeAllObjects];
}

-(id)deleteNodeAtIndex:(int)idx {
	int count = [nodeList count];
	if(count == 0){
		return nil;
	}
	
	if(idx < count) {
		Node* node = [nodeList objectAtIndex:idx];
		[node retain];
		[nodeList removeObjectAtIndex:idx];
		DBG(@"Node[%d] %@/%@ removed, left nodes %d",idx,[node text], [node html],[nodeList count]);
		return [node autorelease];
	}
	return nil;
}

-(id)nodeAtIndex:(int)index{
	int count = [nodeList count];
	if(count == 0){
		return nil;
	}
	if(index < count) {
		return [nodeList objectAtIndex:index];
	}
	return nil;
}
@end


/***************************************************************
 * UIRichTextView Class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIRichTextView

-(id)initWithFrame:(CGRect) rect {
	self = [super initWithFrame:rect];
	if(self) {
		richText = [[NSMutableString alloc] init];
		parser = [[RichTextParser alloc]init];
#ifdef __BUILD_FOR_2_0__
		[self setDelegate:self];
#else
		[[self textTraits] setEditingDelegate:self];
#endif
	}
	return self;
}

-(void)dealloc {
	RELEASE(richText);
	RELEASE(parser);
	[super dealloc];
}

-(void)_parseText:(NSString*)input {
	[parser reset];
	for(int i = 0;i < [input length];i++) {
		[parser appendChar:[input characterAtIndex:i]];
	}
}

-(void)setRichText:(NSString*)aString {
	DBG(@">>>>> setRichText() called");
	DBG(@">>> set rich text:%@",aString);

	[self _parseText:aString];
	NSString* htmlResult = [parser html];
	NSString* textResult = [parser text];

	DBG(@">>> plain text:%@",textResult);
	DBG(@">>> html text:%@",htmlResult);
#ifdef __BUILD_FOR_2_0__
	[super setContentToHTMLString:htmlResult];
#else
	[super setHTML:htmlResult];
#endif
	[richText setString:textResult];
}

-(void)setText:(NSString*)aString {
	DBG(@">>>>> setText() called");
	[self setRichText:aString];
}

-(NSString*)text {
	//LOG(@">>>>> text() called");
	if(richText == nil) {
		return nil;
	}
	return [NSString stringWithFormat:@"%@",richText];
}


// Insert text handler
-(void) _handleInsert:(NSRange)range text:inputString
{
	DBG(@">>> INSERT %@ at %d",inputString,range.location);

	if(range.location == [richText length]) {
		// Append at the end
		for(int i = 0;i < [inputString length];i++) {
			[parser appendChar:[inputString characterAtIndex:i]];
		}
		[richText appendString:inputString];
	} else {
		// Insert char into current text
		[richText insertString:inputString atIndex:(range.location)];
		[self _parseText:richText];
	}

	DBG(@">>> Current text:%@",richText);
	NSString* html = [parser html];
	DBG(@">>> Current html:%@",html);
#ifdef __BUILD_FOR_2_0__
	[self setContentToHTMLString:html];
#else
	[self setHTML:html];
#endif
	range.location++;
	//	range.length=0;
#ifdef __BUILD_FOR_2_0__
	[self setSelectedRange:range];
#else
	[self setSelectionRange:range];
#endif
}

// Delete char handler
-(void) _handleDelete:(NSRange)range
{
	int location = range.location; // Current delete location
	Node* node = [parser deleteNodeAtIndex:location];
	if(node == nil && location > 0){
		--location;
		// no node here ? try previous one
		node = [parser deleteNodeAtIndex:location];
	}
	if(node){
		DBG(@"Node[%d] %@/%@  deleted",location,[node text],[node html]);	
	}
	[richText setString:[parser text]];
}

#ifdef __BUILD_FOR_2_0__
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
       if ( [text length] == 0 )
          [self _handleDelete:range];
       else
          [self _handleInsert:range text:text];

       return NO;
}

#else
// 1.x delegate for keyboard input
-(BOOL)keyboardInput:(id)k shouldInsertText:(NSString*)inputString isMarkedText:(int)b {
	NSRange range = [self selectionRange];
        [self _handleInsert:range Text:inputString];
        return NO;
}

//- (BOOL) webView:(id)fp8 shouldInsertText:(NSString*)inputString replacingDOMRange:(struct _NSRange)range givenAction:(int)fp20{
//	LOG(@"webView %@ shouldInsertText:%@ replacingDOMRange %d,%d givenAction %d",fp8,inputString,range.location,range.length,fp20);
////	if([inputString length] > 0){
////		LOG(@"got input: %@",inputString);
////		[parser appendChar:[inputString characterAtIndex:0]];
////		[super setText:[parser text]];
////		[super setHTML:[parser html]];
////		[super setSelectionToEnd];
////		return NO;
////	}
//	return [super webView:fp8 shouldInsertText:inputString replacingDOMRange:range givenAction:fp20];
//}
// WebEditingDelegate callback - for WebView object - see Apple's WebKit documentation.
- (BOOL) webView:(id)fp8 shouldDeleteDOMRange:(id)domRange {
	NSRange range = [self selectionRange];
	//LOG(@"webView %@ shouldDeleteDOMRange %@, at %d/%d",fp8,domRange,range.location,range.length);
	
//	Node* node = [parser nodeAtIndex:(range.location)];
//	if([[node html] count] > 0){
//		// It's a html node ?
//	}
//	
	[self _handleDelete:range];
	return [super webView:fp8 shouldDeleteDOMRange:domRange];
}
#endif

@end
