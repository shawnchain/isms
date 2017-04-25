//==============================================================================
//	Created on 2007-11-18
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
#import "UIMessageTableCell.h"
#import <WebCore/WebFontCache.h>
#import <UIKit/UIDateLabel.h>
//#include <time.h>
#include "Log.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>
#endif

#import <UIKit/UITextLabel.h>

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIMessageTableCell
/*
 - (void)removeControlWillHideRemoveConfirmation:(id)fp8
 {
 [self _showDeleteOrInsertion: NO withDisclosure: NO animated: YES isDelete: YES andRemoveConfirmation: NO];
 }
 */
/*
#define ONE_WEEK_INTERVAL (7 * 24 * 3600)
-(NSString*) _formatDate:(NSDate*) date{
	if(date == nil){
		return @"01/01/70";
	}
	NSString* dateFormat = @"%y/%m/%d";
	
	NSTimeInterval secSinceNow = [date timeIntervalSinceNow];
	if(secSinceNow < ONE_WEEK_INTERVAL){
		NSCalendarDate* today = [NSCalendarDate calendarDate];
		//NSCalendarDate* smsDate = [[NSCalendarDate alloc] initWithString: [aDate description]];
		NSCalendarDate* smsDate = [date dateWithCalendarFormat:nil timeZone:nil];
		unsigned int tdoy = [today dayOfYear];
		unsigned int sdoy = [smsDate dayOfYear];

		if( tdoy == sdoy ){
			// In the same day!
			//dateFormat = @"Today %H:%M";
			dateFormat = @"%H:%M:%S";
		}else if(tdoy == (sdoy + 1)){
			//dateFormat = @"Yesterday %H:%M";
			dateFormat = NSLocalizedStringFromTable(@"Yesterday",@"iSMS",@"");
		}else if([today dayOfWeek] > [smsDate dayOfWeek]){
			dateFormat = @"%A";
			// In the same week!
		}
	}else if(secSinceNow < 0){
		//return @"Future?";
		dateFormat = @"Future(%y/%m/%d %H:%M:%S)";
	}
	return [date descriptionWithCalendarFormat:dateFormat timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}
*/

-(id)initWithMessage:(Message*) message{
	return [self initWithMessage:message showMessageDirection:YES];
}

//FIXME remove dependency to the message!
-(id)initWithMessage:(Message*) message showMessageDirection:(BOOL) showDirectionValue{
	//NSLog(@"Cell:initWithMessage() called");
	self = [super init];
	if(!self){
		return nil;
	}

	// Quit fast if data is null!
	if(message == nil) {
		return self;
	}

	// Show the left arrow
	[self setDisclosureStyle: 1];
	[self setShowDisclosure: YES];
	showMessageDirection = showDirectionValue;
	
	// Data to display
	//NSString *msgId = [message msgId];
	//NSString *date=	[message date];
	NSString *msgBody=	[message body];
	NSString *sender = [message getSenderName];
	if(sender == nil){
		sender = [message phoneNumber];
	}
	
	// Added blut-dot image if messag is unread
	// The position is fixed
	if(![message hasBeenRead]){
		UIImage* blueDot = [UIImage applicationImageNamed:@"blue_dot.png"];
		iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10,25,13,13)];
		[iconView setImage:blueDot];
		[self addSubview:iconView];
		//[self setImage:blueDot];
	}

	// Color definition
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float transparentComponents[4] = {0, 0, 0, 0};
	//float grayComponents[4] = {0.55, 0.55, 0.55, 1};
	float whiteComponents[4] = { 1., 1., 1., 1. };
	float textgrayComponents[4] = {0.35, 0.35, 0.35, 1};
	float blueComponents[4] = {0.208, 0.482, 0.859, 0.8};

#ifndef __BUILD_FOR_2_0__
	struct __GSFont * textfont=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:13];
#endif

	// Sender Label
	senderLabel = [[UITextLabel alloc] init/*initWithFrame:CGRectMake(20.0f, 3.0f, 210.0f, 32.0f)*/];
	NSString* senderLabelText = sender;
	if(showMessageDirection){
		if([message isOutgoing]){
			senderLabelText = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"To:",@"iSMS",@""),sender];
		}else{
			senderLabelText = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"From:",@"iSMS",@""),sender];
		}
	}
	[senderLabel setText:senderLabelText];
	[senderLabel setWrapsText:YES];

        CGColorRef transparentColor = CGColorCreate(colorSpace, transparentComponents);
	CGColorRef whiteColor = CGColorCreate(colorSpace, whiteComponents);
#ifdef __BUILD_FOR_2_0__
	[senderLabel setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
	[senderLabel setHighlightedColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[senderLabel setBackgroundColor:transparentColor];
	[senderLabel setHighlightedColor:whiteColor];
#endif
        CGColorRelease(transparentColor);
        CGColorRelease(whiteColor);

	[self addSubview:senderLabel];
	
	// Message Content Label
	textLabel = [[UITextLabel alloc] init /*initWithFrame:CGRectMake(20.0f, 35.0f, 250.0f, 26.0f)*/];
	if([msgBody length]>80) {
		[textLabel setText:[msgBody substringToIndex:80]];
	} else {
		[textLabel setText:msgBody];
	}

        CGColorRef textgrayColor = CGColorCreate(colorSpace, textgrayComponents);
        transparentColor = CGColorCreate(colorSpace, transparentComponents);
        whiteColor = CGColorCreate(colorSpace, whiteComponents);
#ifdef __BUILD_FOR_2_0__
	[textLabel setFont:[UIFont systemFontOfSize:13]];
	[textLabel setColor:[UIColor colorWithCGColor:textgrayColor]];
	[textLabel setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
	[textLabel setHighlightedColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[textLabel setFont:textfont];
	[textLabel setColor:textgrayColor];
	[textLabel setBackgroundColor:transparentColor];
	[textLabel setHighlightedColor:whiteColor];
#endif
        CGColorRelease(textgrayColor);
        CGColorRelease(transparentColor);
        CGColorRelease(whiteColor);

#ifndef __BUILD_FOR_2_0__
	CFRelease(textfont);
#endif

	[textLabel setWrapsText:YES];
	[self addSubview:textLabel];
	
	//dateLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(250.0f, 8.0f, 100.0f, 26.0f)];
	dateLabel = [[UIDateLabel alloc] initWithFrame:CGRectMake(250.0f, 6.0f, 100.0f, 26.0f)];

        CGColorRef blueColor = CGColorCreate(colorSpace,blueComponents); 
	transparentColor = CGColorCreate(colorSpace,transparentComponents);
        whiteColor = CGColorCreate(colorSpace, whiteComponents);
#ifdef __BUILD_FOR_2_0__
	[dateLabel setTextColor:[UIColor colorWithCGColor:blueColor]];
	[dateLabel setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
	[dateLabel setHighlightedTextColor:[UIColor colorWithCGColor:whiteColor]];
	[dateLabel setFont:[UIFont systemFontOfSize:14]];
#else
	[dateLabel setColor:blueColor];
	[dateLabel setBackgroundColor:transparentColor];
	[dateLabel setHighlightedColor:whiteColor];
	struct __GSFont * font = [NSClassFromString(@"WebFontCache")	createFontWithFamily:@"Helvetica" traits:2 size:14];
	[dateLabel setFont:font];
	CFRelease(font);
#endif
        CGColorRelease(blueColor);
        CGColorRelease(transparentColor);
        CGColorRelease(whiteColor);
    
	[dateLabel setDate:[message date]];
	//[dateLabel setText:[self _formatDate:[message date]]];
	[dateLabel sizeToFit];
	// Right alignment
	CGRect _newRect = [dateLabel frame];
	_newRect.origin.x = (290. - _newRect.size.width);
	[dateLabel setFrame:_newRect];
	[self addSubview:dateLabel];
	
        CGColorSpaceRelease(colorSpace);

	return self;
}

/*
 * Position your subviews in layoutSubviews.
 * This sample also works if you are supporting
 * isRemoveControlVisible == YES or isReorderingEnabled == YES
 * by reducing the width of your control by the appropriate amount
 * based on the contentBounds
 */
- (void) layoutSubviews {
	[super layoutSubviews];
	
	// using contentBounds instead of frame because it gets updated for remove and reording controls being visible
	CGRect contentBounds = [self contentBounds];
	CGRect frame = contentBounds;
	DBG(@"LayoutSubviews() contentBounds %f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
	//NSLog(@"contentBounds: %f %f %f %f",contentBounds.origin.y,contentBounds.origin.x,contentBounds.size.width, contentBounds.size.height);
	//NSLog(@"[self isRemoveControlVisible] = %i", [self isRemoveControlVisible]);
	//NSLog(@"[self isReorderingEnabled] = %i", [self isReorderingEnabled]);
	
	// Layout cell according to it's state.
	// 1. normal mode, display blue dot for new, and all x + 28
	// 2. edit mode, hide blue dot and x + 8
	
	if(frame.origin.x > 0){
	//if([self isRemoveControlVisible]){
		//x2,y3,w210,h32
		frame.origin.x = contentBounds.origin.x + 8.;
		frame.origin.y = contentBounds.origin.y + 5.;
		frame.size.width = contentBounds.size.width - frame.origin.x;
		//frame.size.width = 200.;
		frame.size.height = 16.;
		[senderLabel setFrame:frame];
			
		//x20,y25,w250,h26
		frame.origin.x = contentBounds.origin.x + 10.;
		frame.origin.y = contentBounds.origin.y + 25.;
		frame.size.width = contentBounds.size.width - frame.origin.x;
		//frame.size.width = 250.;
		frame.size.height = 32.;
		[textLabel setFrame:frame];
	}else{
		//x2,y3,w210,h32
		frame.origin.x = contentBounds.origin.x + 13.;
		frame.origin.y = contentBounds.origin.y + 5.;
		frame.size.width = contentBounds.size.width -13.;
		//frame.size.width = 220.;
		frame.size.height = 16.;
		[senderLabel setFrame:frame];
			
		//x20,y25,w250,h26
		frame.origin.x = contentBounds.origin.x + 25.;
		frame.origin.y = contentBounds.origin.y + 25.;
		frame.size.width = contentBounds.size.width -25.;
		//frame.size.width = 270.;
		frame.size.height = 32.;
		[textLabel setFrame:frame];
	}
}

- (void) updateHighlightColors {
	[super updateHighlightColors];

	BOOL hilited = [self isSelected];
	[senderLabel setHighlighted:hilited];
	[dateLabel setHighlighted:hilited];
	[textLabel setHighlighted:hilited];
}

-(void)dealloc{
	RELEASE(iconView);
	RELEASE(senderLabel);
	RELEASE(dateLabel);
	RELEASE(textLabel);
	[super dealloc];
}
@end
