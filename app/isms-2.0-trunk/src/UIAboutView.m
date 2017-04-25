//==============================================================================
//	Created on 2007-12-9
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
/*
 * Copyright WeIPhone Dev Team 
 * http://www.weiphon.com
 * 
 *
 *
 *   
 *   Rev History: 
 *								 
 *    first version by laoren
 *	  guohongtao@gmail.com
 */

#import "UIAboutView.h"
#import "iSMSApp.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIScroller.h>
#import <UIKit/UIWebView.h>
#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Hierarchy.h>
#endif
#import "Log.h"

@interface MyTextView : UITextView
@end

struct HackedGSPathPoint{
	char unk0;
	char unk1;
	short int status;
	int unk2;
	float x;
	float y;
};

typedef struct {
	int unk0;
	int unk1;
	int type;
	int subtype;
	float unk2;
	float unk3;
	float x;
	float y;
	int timestamp1;
	int timestamp2;
	int unk4;
	int modifierFlags;
	int unk5;
	int unk6;
	int mouseEvent;
	short int dx;
	short int fingerCount;
	int unk7;
	int unk8;
	char unk9;
	char numPoints;
	short int unk10;
	//struct HackedGSPathPoint points[numPoints];
	struct HackedGSPathPoint *points;
} HackedGSEvent;

@implementation MyTextView
//- (void) mouseUp:(struct __GSEvent *)event{
//	HackedGSEvent *e = (HackedGSEvent*)event;
//	LOG(@"Mouse up event:fingersCount %d",e->fingerCount);
//	LOG(@"Mouse up event:numPoints %d",e->numPoints);
//	
//	[super mouseUp:event];
//}
//
//- (void) mouseDown:(struct __GSEvent *)event{
//	HackedGSEvent *e = (HackedGSEvent*)event;
//	LOG(@"Mouse down event:fingersCount %d",e->fingerCount);
//	LOG(@"Mouse down event:numPoints %d",e->numPoints);
//	
//	// If e->fingerCount is 5, popup the special alert ?
//	[super mouseDown:event];
//}
@end


@class WebPolicyDecisionListenerPrivate;

@protocol WebPolicyDecisionListener <NSObject>
- (void)use;
- (void)download;
- (void)ignore;
@end

@interface WebPolicyDecisionListener : NSObject <WebPolicyDecisionListener>
{
    WebPolicyDecisionListenerPrivate *_private;
}

- (id)_initWithTarget:(id)fp8 action:(SEL)fp12;
- (void)dealloc;
- (void)release;
- (void)_usePolicy:(int)fp8;
- (void)_invalidate;
- (void)use;
- (void)ignore;
- (void)download;
- (void)continue;

@end


/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIAboutView
+(UIAboutView*)sharedInstance{
	return (UIAboutView*)[[iSMSApp getInstance] getViewForName:@"UIAboutView"];
}

-(id)initWithFrame:(struct CGRect)frame{
	self=[super initWithFrame:frame];
	if(self == nil) {
		return nil;
	}
		
	aboutField =[[MyTextView alloc] initWithFrame:[self frame]];
	
#ifdef __BUILD_FOR_2_0__
	[[aboutField webView] setDelegate:self];
#else
	[[aboutField _webView] setDelegate:self];
#endif
	
	NSURL *url = [NSURL URLWithString:@"file:///Applications/iSMS2.app/about.html"];
	
	NSMutableString *aboutContent = [NSMutableString stringWithCapacity:2048];
	if(url){
		NSString *fromFile = [[NSString alloc] initWithContentsOfURL:url encoding: NSUTF8StringEncoding error:NULL];
		if(fromFile && [fromFile length] > 0 /*&& [fromFile length] == 2206*/){
			[aboutContent appendString:fromFile];
			//NSLog(@"content length:%d",[fromFile length]);
		}
	}
	if(aboutContent == nil || [aboutContent length] == 0){
		NSString *embedded = @"<p>iSMS-2.0 copyrighted by Shawn(shawn.chain@gmail.com), Holly Lee(holly.lee@gmail.com). </p>"\
				"<p>Please visit http://code.google.com/p/weisms/ for bug report or comments.</p>"\
				"<p>Some code is based on WeSMS copyrighted by Laoren/ChinaET and http://www.weiphone.com </p>"\
				"<p>Thanks for the WeiPhone test team: sealzhou,davidleslie...</p>"\
				"<p>Use for business purpose is forbidden. Punishment: <small>Monkeys coming out of your ass Bruce Almighty style.</small></p>";
		NSString *chinese = [NSString stringWithUTF8String:"<p>禁止将本程序以商业目的进行销售与分发！违者tjjtds</p>"];
		[aboutContent appendString:embedded];
		[aboutContent appendString:chinese];
	}		
#ifdef __BUILD_FOR_2_0__
	[aboutField setFont:[UIFont systemFontOfSize:16]];
	[aboutField setContentToHTMLString:aboutContent];
#else
	[aboutField setTextSize:16];
	[aboutField setHTML:aboutContent];
#endif
	[aboutField setEditable:NO];
	[aboutField setContentSize:CGSizeMake(320,800)];
	[aboutField setAllowsRubberBanding: YES];
	  
	[self addSubview:aboutField];
	//[aboutField displayScrollerIndicators];

	return self;
}

@class WebView;

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
	LOG(@"decidePolicyForNavigationAction called!");
}

-(void)dealloc{
	[aboutField release];
	[super dealloc];
}

#ifdef DEBUG
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL rts = [super respondsToSelector:sel];
  LOG(@"%@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
  return rts;
}
#endif

-(void)didShow:(NSDictionary*)param{
	[aboutField displayScrollerIndicators];
}
@end
