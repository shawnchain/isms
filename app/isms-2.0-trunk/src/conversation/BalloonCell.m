//
//  BalloonCell.m
//  MobileChatApp
//
//  Created by Shaun Harrison on 9/1/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import "Prefix.h"
#import "BalloonCell.h"
//#import "HTMLHandler.h"
#import <UIKit/UIKit.h>
//#import "Theme.h"
#import "UIRichTextView.h"
#import "HTMLHandler.h"

#import <UIKit/NSString-UIStringDrawing.h>
#import <WebCore/WebFontCache.h>
#import <GraphicsServices/GraphicsServices.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIImage-UIImageDeprecated.h>
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UITextLabel.h>
#endif

static int BALLOON_SEND_STYLE = 1;
static int BALLOON_RECV_STYLE = 2;

@implementation BalloonCell

-(id)initWithText:(NSString*)aText direction:(BOOL)direction{
	[super init];
	[self setShowSelection: NO];
	[self setText:aText send:direction];
	return self;
}

- (void) setText: (NSString*)_message send: (BOOL)send {
	DBG(@"message: %@", _message);
	// 1. calculate the text width/height
	// 	This flattens the HTML since as of right now,
	// 	the iPhone is missing NSAttributedString
//	UITextView* flatText = [[UITextView alloc] init];
//	[flatText setHTML: [HTMLHandler nl2br:_message]];
//	_message = [[flatText text] copy];
//	[flatText release];
	
//	DBG(@"message after flattern: %@", _message);
//	NSString* messageAndFont = [NSString stringWithFormat: @"<span style='font-family: Helvetica; font-size: 14px; line-height: 16px'>%@</span>",
//													[HTMLHandler nl2br:_message]];
//	NSString* messageAndFont = [NSString stringWithFormat: 
//		@"<span style='font-family: Helvetica; font-size: 14px; line-height: 16px'>%@</span>",
//		_message];
//	NSString* messageAndFont = [NSString stringWithFormat: 
//		@"<pre>%@</pre>",
//		_message];
//	NSLog(@"_message2: %@", messageAndFont);
	
	//CGSize ts = [messageAndFont sizeWithMarkupForWidth:230.0f];
	//CGSize ts = [messageAndFont sizeWithStyle:@"font-family: Helvetica; font-size: 14px; line-height: 16px" forWidth:230.0f];
	//CGSize ts = [_message sizeWithFont:font forWidth:230.0f ellipsis:1];
	//NSLog(@"text size = %f x %f", sss.width, sss.height);
	
	//CGSize ts = [BalloonCell textSizeWithWidth:260.0f text:/*[HTMLHandler nl2br:_message]*/_message];
	CGSize ts = [BalloonCell textSizeWithLineLength:13 text:_message];
	DBG(@"message text size = %f x %f", ts.width, ts.height);
	
	/*
	CGRect _aRect = CGRectMake(0,0,220,480);
	UITextLabel *_aLabel = [[UITextLabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
	[_aLabel setWrapsText:YES];
	[_aLabel setText:_message];
	[_aLabel setFrame:_aRect];
	CGSize _aSize = [_aLabel textSize];
	DBG(@"Text width:%f, height:%f",_aSize.width,_aSize.height);
	[_aLabel release];
	*/
	
	// Store the height
	height = ts.height;
	
	CGRect textRect = CGRectMake(0.0f, 0.0f, ts.width, ts.height);
	
	// 2. Create the background view according to the text size
	UIView *bubbleView = [self _createBubbleViewWithRect: textRect outgoing:send];
	[self addSubview:bubbleView];

	// 3. Create the corresponding text view
	if(text){
		[text removeFromSuperview];
		RELEASE(text);
	}
	
	CGRect bubbleRect = [bubbleView frame];
	if(send){
		textRect.origin.x = bubbleRect.origin.x + 6.0f;
	}else{
		textRect.origin.x = bubbleRect.origin.x + 14.0f;
	}
	textRect.origin.y = bubbleRect.origin.y + 5.0f;
	//textRect.size.width -= 4.0f;
	
	/*
	float x = send ? [bubbleView frame].origin.x:7.0f;
	textRect.origin = CGPointMake(x + 10.0f, 4.0f);
	if(!send){
		textRect.size.width-=20.0f;	
	}else{
		textRect.size.width-=8.0f;
	}
	*/
	
	UITextLabel *label = [[UITextLabel alloc]initWithFrame:textRect];
	[label setWrapsText:YES];

	float transparent[4] = {0, 0, 0, 0};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef transparentColor = CGColorCreate(colorSpace, transparent);
#ifdef __BUILD_FOR_2_0__
	[label setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
#else
	[label setBackgroundColor:transparentColor];
#endif
        CGColorRelease(transparentColor);
	CGColorSpaceRelease(colorSpace);

	[label setOpaque:YES];
	[self addSubview:label];
	[label setText:_message];
	[label release];
	
	/*
	text = [[UITextView alloc] initWithFrame: textRect];
	[text setEditable:NO];
	//[text setHTML:[HTMLHandler nl2br:_message]];
	[text setTextSize: 17.0f];
	[text setMarginTop: 0.0f];
	[text setBottomBufferHeight: 0.0f];
	
	float transparent[4] = {0, 0, 0, 0};
	[text setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), transparent)];
	[text setOpaque:YES];
	[text setText:_message];
	[text setNeedsDisplay];
	//[text setFrame: textRect];
	[self addSubview: text];
	[text release];
	*/
	//[text setNeedsDisplay];
}

-(UIView*)_createBubbleViewWithRect:(CGRect)rect outgoing:(BOOL)outgoing{
	UIView *aView;
	if(outgoing){
		// Align to right
		rect.origin.x = 320 - rect.size.width - 12.0f;
		rect.size.height += 12.0f;
		rect.size.width += 14.0f;
		height = rect.size.height + 7.0f;
	}else{
		// Align to left
		rect.size.height += 12.0f;
		rect.size.width += 14.0f;
		height = rect.size.height + 7.0f;
	}
	
	int style = (outgoing?BALLOON_SEND_STYLE:BALLOON_RECV_STYLE);
	aView = [[BalloonCellBack alloc] initWithFrame:rect style:style];
	return [aView autorelease];
}

- (float) height {
	return height;
}

static BOOL _isASCII(unichar aChar){
	return (aChar & 0xff00) == 0;
}

static BOOL _isEOLChar(unichar aChar){
	if((aChar & 0xff00) > 0 ){
		// Higher byte is non-zero, might be CJK
		return NO;
	}
	switch(aChar){
//		case (unichar)' ':
		case (unichar)'\t':
		case (unichar)'\n':
		case (unichar)'\r':
//		case (unichar)',':
			return YES;
		default:
			return NO;
	}
}

static float _calculateTextWidth(NSString* str){
	static UITextLabel* line;
	if(!line){
		line = [[UITextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	}
	[line setWrapsText: YES];
	[line setText:str];
	[line _invalidateTextSize];
	float width = [line textSize].width;
	return width;
}

static float _calculateSingleCharWidth(){
	static float result = 0;
	if(result == 0){
		UITextLabel* line = [[UITextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[line setWrapsText: YES];
		NSString *str = [NSString stringWithUTF8String:"\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60\x4f\x60"];
		//[line setText:@"abcdeABCDE"];
		[line setText:str];
		[line _invalidateTextSize];
		result = [line textSize].width / 28.0f;
		[line release];
	}
	return result;
}

#define DEFAULT_ASCII_CHAR_WIDTH 9.0f//9.185f
+(CGSize) textSizeWithLineLength:(int)maxLineLen text:(NSString*)text{
	int lineCount = 0;
	int currentLineLen = 0;
	int currentMaxLineLen = 0;
	int textLen = [text length];
	for(int pos = 0;pos < textLen; pos++){
		unichar aChar = [text characterAtIndex:pos];
		if(_isASCII(aChar)){
			currentLineLen++;
		}else{
			currentLineLen+=2;
		}
		if(currentLineLen > currentMaxLineLen){
			currentMaxLineLen = currentLineLen;
		}
		if(_isEOLChar(aChar) || currentLineLen >= (maxLineLen * 2)){
			lineCount++;
			currentLineLen=0;
		}
	}
	
	if(currentLineLen > 0){
		// We have unfinished line
		lineCount++;
	}
	DBG(@"Line count %d",lineCount);
	DBG(@"Max line length: %d",currentMaxLineLen);
	float textHeight = (float)(lineCount) * 20.f;

	if(currentMaxLineLen < 4){
		currentMaxLineLen = 4;
	}else if(currentMaxLineLen % 2 == 1){
		currentMaxLineLen++;
	}
	//float textWidth = ((float)(currentMaxLineLen /*+ 2*/)) * _calculateSingleCharWidth();
	float textWidth = ((float)currentMaxLineLen) * DEFAULT_ASCII_CHAR_WIDTH;
	return CGSizeMake(textWidth,textHeight);
}

// Inspired by ApolloIM & MobileChat
+ (CGSize) textSizeWithWidth:(float)maxWidth text:(NSString*)text {
	float textWidth = 0.0f;
	int lineCount = 0;
	
	int textLen = [text length];
	NSMutableString	*buf = [[NSMutableString alloc]init];
	for(int pos = 0;pos<textLen;pos++){
		unichar aChar = [text characterAtIndex:pos];
		[buf appendFormat:@"%C", aChar];
		
		float currentWidth = _calculateTextWidth(buf);
		if(currentWidth > textWidth){
			textWidth = currentWidth;
		}		
		if(currentWidth > (maxWidth - 20.f) || _isEOLChar(aChar)){
			// A new line!
			lineCount++;
			DBG(@"Line(%d), width(%f), %@",lineCount,currentWidth,buf);
			[buf setString:@""];
		}
	}
	
	// Assume line height is 20
	float textHeight = (float)(lineCount+1) * 20.0f;
	
	return CGSizeMake(textWidth + 18.0f,textHeight);
}

- (BOOL)showSelection {
	return NO;
}
//
//- (void)setSelected:(BOOL)flag { }
//
//- (BOOL)isSelected {
//	return NO;
//}

//- (void)updateHighlightColors { }

//- (void)setSelected:(BOOL)fp8 withFade:(BOOL)fp12 { }

-(void)setNeedsDisplay{
	[super setNeedsDisplay];
	[text setNeedsDisplay];
}

//-(NSString*)description{
//	return [NSString stringWithFormat:@"%@, %@",self,[text text]];
//}
@end

@implementation BalloonCellBack
- (id) initWithFrame: (CGRect) rect style: (int) style {
	self = [super initWithFrame: rect];
	_style = style;
	//NSLog(@"BalloonCellBack>1");
	//if((_style == BALLOON_RECV_STYLE && [[Theme instance] recvFlip]) || (_style == BALLOON_SEND_STYLE && [[Theme instance] sendFlip])) {
	if(_style == BALLOON_RECV_STYLE){
		//NSLog(@"BalloonCellBack>1a");
		CGAffineTransform transform =  CGAffineTransformScale (CGAffineTransformMake(1, 0, 0, 1, 0, 0), -1, 1);
		//NSLog(@"BalloonCellBack>1b");
		[self setTransform: transform];
		//NSLog(@"BalloonCellBack>1c");
	}
	//NSLog(@"BalloonCellBack>2");
	[self setOpaque: NO];
	return self;
}

- (void) drawRect: (CGRect) rect {
//	CDAnonymousStruct11 slices;
	UIImage* img;

	if(_style == BALLOON_SEND_STYLE) {
		//FLIP = NO
		img = [UIImage applicationImageNamed:@"balloon_1.png"];//[[Theme instance] sendImg];
		//slices = [[Theme instance] sendSlices];
		// dict = Bubbles->send->slices
		//NSDictionary* tdict = [dict objectForKey: @"top"];		
		CGRect t_left		= CGRectMake(0,0,17,14);//[self rectFromDict: [tdict objectForKey: @"left"]];
		CGRect t_middle	= CGRectMake(17,0,2,14);//[self rectFromDict: [tdict objectForKey: @"middle"]];
		CGRect t_right	= CGRectMake(19,0,24,14);//[self rectFromDict: [tdict objectForKey: @"right"]];
		// CDAnonymousStruct4 top = {t_left, t_middle, t_right};
		
		//NSDictionary* mdict = [dict objectForKey: @"middle"];
		CGRect m_left	= CGRectMake(0,14,2,1);//[self rectFromDict: [mdict objectForKey: @"left"]];
		CGRect m_middle	= CGRectMake(17,14,2,1);//[self rectFromDict: [mdict objectForKey: @"middle"]];
		CGRect m_right	= CGRectMake(19,14,24,1);//[self rectFromDict: [mdict objectForKey: @"right"]];
		
		//NSDictionary* bdict = [dict objectForKey: @"bottom"];
		CGRect b_left	= CGRectMake(0,15,17,17);//[self rectFromDict: [bdict objectForKey: @"left"]];
		CGRect b_middle	= CGRectMake(17,15,2,17);//[self rectFromDict: [bdict objectForKey: @"middle"]];
		CGRect b_right	= CGRectMake(19,15,24,17);//[self rectFromDict: [bdict objectForKey: @"right"]];
		
#ifdef __BUILD_FOR_2_0__
		CDAnonymousStruct13 slices = {{t_left, t_middle, t_right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#else
		CDAnonymousStruct11 slices = {{t_left, t_middle, t_right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#endif
		[img draw9PartImageWithSliceRects: slices inRect: rect];
	} else {
		//FLIP = YES
		//img = [[Theme instance] recvImg];
		img = [UIImage applicationImageNamed:@"balloon_2.png"];//[[Theme instance] sendImg];
		//slices = [[Theme instance] recvSlices];
		// dict = Bubbles->recv->slices
		//NSDictionary* tdict = [dict objectForKey: @"top"];		
		CGRect t_left		= CGRectMake(0,0,17,14);//[self rectFromDict: [tdict objectForKey: @"left"]];
		CGRect t_middle	= CGRectMake(17,0,2,14);//[self rectFromDict: [tdict objectForKey: @"middle"]];
		CGRect t_right	= CGRectMake(19,0,24,14);//[self rectFromDict: [tdict objectForKey: @"right"]];
		// CDAnonymousStruct4 top = {t_left, t_middle, t_right};
		
		//NSDictionary* mdict = [dict objectForKey: @"middle"];
		CGRect m_left	= CGRectMake(0,14,2,1);//[self rectFromDict: [mdict objectForKey: @"left"]];
		CGRect m_middle	= CGRectMake(17,14,2,1);//[self rectFromDict: [mdict objectForKey: @"middle"]];
		CGRect m_right	= CGRectMake(19,14,24,1);//[self rectFromDict: [mdict objectForKey: @"right"]];
		
		//NSDictionary* bdict = [dict objectForKey: @"bottom"];
		CGRect b_left	= CGRectMake(0,15,17,17);//[self rectFromDict: [bdict objectForKey: @"left"]];
		CGRect b_middle	= CGRectMake(17,15,2,17);//[self rectFromDict: [bdict objectForKey: @"middle"]];
		CGRect b_right	= CGRectMake(19,15,24,17);//[self rectFromDict: [bdict objectForKey: @"right"]];
		
#ifdef __BUILD_FOR_2_0__
		CDAnonymousStruct13 slices = {{t_left, t_middle, t_right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#else
		CDAnonymousStruct11 slices = {{t_left, t_middle, t_right}, {m_left, m_middle, m_right}, {b_left, b_middle, b_right}};
#endif
		[img draw9PartImageWithSliceRects: slices inRect: rect];
	}
}

@end
