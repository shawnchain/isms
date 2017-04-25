//==============================================================================
//	Created on 2007-12-16
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
// Some code is credited Allen Porter <allen@thebends.org>
//

#import "Prefix.h"
#import "UISmileyChooserView.h"
#import <UIKit/UITile.h>
#import <UIKit/UIView-Internal.h>
#import <UIKit/UIView-Hierarchy.h>
// #import <CoreSurface/CoreSurface.h>
#import <UIKit/UIValueButton.h>
#include <math.h>
#import "Log.h"

#import "SmileyManager.h"
#import "AnimationHelper.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIImage-UIImagePrivate.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UIAnimation.h>
#endif

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@interface RandomColorTile : UITile
{
	int index;
}
@end

@implementation RandomColorTile

- (void)logRect:(struct CGRect)rect;
{
	DBG(@"(%f,%f) -> (%f,%f)", rect.origin.x, rect.origin.y,
			rect.size.width, rect.size.height);
}

- (id)initWithFrame:(struct CGRect)frame
{
	self = [super initWithFrame:frame];
	DBG(@"init smiley chooser view with frame %@",frame);
	//[self logRect:frame];
	if(self) {

		UIImage* btnImage = [UIImage imageNamed:@"button_blue.png"];
		UIPushButton* btn = [[UIPushButton alloc] initWithTitle:@"" autosizesToFit:NO];
		[btn setFrame: CGRectMake(0, 0, frame.size.width,frame.size.height)];
		[btn setEnabled:NO]; //by default is disabled
		[btn setBackground:btnImage forState:0]; //up state
		[self addSubview:btn];
		[btn release];
		//[btnSend setBackground:btnImageOn forState:1]; //down state
		//[btnSend setTitleFont:buttonTitleFont];
		//[btnSend setDrawContentsCentered:YES];
		//[btnSend setDrawsShadow: YES];
		//[btnSend setShowPressFeedback:YES];
		//[btnSend addTarget:self action:@selector(sendSMS) forEvents:1];
	}
	[self setUserInteractionEnabled:YES];
	return self;
}

//- (void)drawRect:(struct CGRect)rect
//{
//  CGContextRef context = UICurrentContext();
//  float r = (float)(rand() % 100) / 100.0;
//  float g = (float)(rand() % 100) / 100.0;
//  float b = (float)(rand() % 100) / 100.0;
//  CGContextSetRGBFillColor(context, r, g, b, 1.0);
//  CGContextFillRect(context, rect);
//}

//-(id)hitTest:( struct CGPoint)point forEvent:( struct __GSEvent *) event {
//	LOG(@"HitTest %d/%d",point.x,point.y);
//	return [super hitTest:point forEvent:event];
//	
//}
@end

@interface UISmileyButton : UIValueButton{ //UIPushButton {
	NSString *value;
}
-(void) setValue:(NSString*)aValue;
-(id)initWithFrame:(CGRect) rect withValue:(NSString*)aValue;
@end

@implementation UISmileyButton
-(id)initWithFrame:(CGRect) rect withValue:(NSString*)aValue {
	self = [super initWithFrame:rect];
	if(self) {
		NSDictionary* smileyMap = [[SmileyManager sharedInstance] availableSmileyMap];
		
		// Setup the image according to the value
		//FIXME read from the smiley manager ?
		NSString *imgPath = SMILEY_LOCATION;
		NSString *imgName = [smileyMap objectForKey:aValue];
		if(!imgName){
			LOG(@"No such smiley found: %@",aValue);
			return self;
		}
		
		NSString *imgFile = [NSString stringWithFormat:@"%@/%@",imgPath,imgName];
		//UIImage* btnImage = [UIImage applicationImageNamed:imgFile];
		UIImage* btnImage = [UIImage imageNamed:imgFile];
		//[self setBackground:btnImage forState:0];
		RETAIN(value,aValue);
		//[super setValue:aValue];
		//[super setLabel:aValue];
		//[self setDisplayStyle:2];
		[self setLabelBadgeImage:btnImage];
		
		//[self setBackgroundImage:btnImage];
		[self setDrawContentsCentered:YES];
		//[self setLabel:aValue];
		//[self sizeToFit];
#ifdef __BUILD_FOR_2_0__
		[self addTarget:self action:@selector(onMouseUp) forControlEvents:UIControlEventTouchUpInside];
#else
		[self addTarget:self action:@selector(onMouseUp) forEvents: kUIControlEventMouseUpInside];
#endif

//		[self addTarget:self action:@selector(onMouseDown) forEvents: kUIControlEventMouseDown];
//		[self addTarget:self action:@selector(onMouseMoveIn) forEvents: kUIControlEventMouseEntered];
//		[self addTarget:self action:@selector(onMouseMoveOut) forEvents: kUIControlEventMouseExited];
	}
	return self;
}

-(void) setValue:(NSString*)aValue {
	RETAIN(value,aValue);
}

-(void)dealloc {
	RELEASE(value);
	[super dealloc];
}

-(void)onMouseUp {
	[self setStretchBackground:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:SMILEY_CHOOSED object:self userInfo:(id)value];
}

-(void)onMouseMoveIn {
	[self setStretchBackground:YES];
}

-(void)onMouseMoveOut {
	[self setStretchBackground:NO];
}

-(void)onMouseDown {
[self setStretchBackground:YES];
}
@end


@implementation ISMSSmileyChooserViewController

-(UIView*)_createSmileyKeyboard {
	UIView *kb = nil;
	CGRect keyboardRect = CGRectMake(0.0f, 44.0f, 320.0f, 460.0f-44.0f );
//	CGRect keyboardRect = [self.view frame];
	kb = [[UIView alloc]initWithFrame:keyboardRect];
	float c[4] = {0.76f, 0.77f, 0.78f, 1.0};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *kbColor = CGColorCreate(colorSpace, c);
	[kb setBackgroundColor:[UIColor colorWithCGColor:kbColor]];
	CGColorRelease(kbColor);
	CGColorSpaceRelease(colorSpace);
	
	NSDictionary* smileyMap = [[SmileyManager sharedInstance] availableSmileyMap];
	LOG(@"%@",smileyMap);
	NSEnumerator *enumerator = [smileyMap keyEnumerator];
	id key = nil;
	int i = 0;
	float x = 0.,y = 0.;
	float width=50.,height=50.;
	CGRect rect;
	UIPushButton* btn = nil;
	while ((key = [enumerator nextObject])) {
		float mod = i % 5;
		if(mod == 0){
			y = (i/5) * 60 + 15;
		}
		x = mod * 64 + 8;
		rect = CGRectMake(x,y,width,height);
		DBG(@"Smiley %@(%f,%f,%f,%f)",key,x,y,width,height);
		btn = [[UISmileyButton alloc]initWithFrame:rect withValue:(NSString*)key];
		[kb addSubview:btn];
		[btn release];
	    i++;
	}
	[kb setUserInteractionEnabled:YES];
	[kb setTapDelegate:self];
	return kb;
}

- (IBAction)onCancel{
    //[self dismissModalViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:SMILEY_CHOOSED object:self userInfo:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// L10N
		/*
		UIBarButtonItem *finBtn=[[UIBarButtonItem alloc] 
								 initWithTitle:@"Cancel"style:UIBarButtonItemStylePlain
								 target:self action:@selector(onCancel)];
		[self.navigationItem setRightBarButtonItem:finBtn];
		[finBtn release];
		*/
	}
	return self;
}

// If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
	// Create the keyboard view and add as child
	[self.navigationItem setTitle:NSLocalizedStringFromTable(@"Smileys",@"iSMS",@"")];
	[[self.navigationItem rightBarButtonItem] setTitle:NSLocalizedStringFromTable(@"Cancel",@"iSMS",@"")];
	// Setup the view style
	/*
	float c[4] = {0., 0., 0., 0.5f};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *bgColor = CGColorCreate(colorSpace, c);
	[self.view setBackgroundColor:[UIColor colorWithCGColor:bgColor]];		
	CGColorRelease(bgColor);
	CGColorSpaceRelease(colorSpace);
	*/
	
	self->smileyKeyboard = [self _createSmileyKeyboard];
	[self.view addSubview:smileyKeyboard];
}

// Callback from mask view
-(void)view:(UIView*) aView handleTapWithCount:(int) count event:(id)aEvent{
	[[NSNotificationCenter defaultCenter] postNotificationName:SMILEY_CHOOSED object:self userInfo:nil];
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)dealloc {
	RELEASE(smileyKeyboard);
	[super dealloc];
}

@end