//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: template.txt 11 2007-11-18 05:35:36Z shawn $
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import "UIButtonBarView.h"
#import "iPhoneDefs.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIToolbar.h>
#import <UIKit/UIToolbar-UIButtonBarPrivate.h>
#import <QuartzCore/QuartzCore.h>
#else
#import <LayerKit/LayerKit.h>
#import <GraphicsServices/GraphicsServices.h>
#endif

@implementation UIButtonBarView

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])!=nil) {
		_buttonBar = [ self createButtonBar ];
		if(_buttonBar) {
			[self addSubview: _buttonBar];
		}
	}
	return self;
}

- (void)_setButtonFrame:(UIView*)btnView btnTag:(int)tag {
	//NOOP
}

-(CGRect)makeButtonBarRect{
	return CGRectMake(0.0f, 460.0f - UI_BOTTOM_BUTTON_BAR_HEIGHT, 320.0f, UI_BOTTOM_BUTTON_BAR_HEIGHT);
}

#ifdef __BUILD_FOR_2_0__
-(UIToolbar *)
createButtonBarSetDelegate:(id)aDelegate setBarStyle:(int)aBarStyle setButtonBarTrackingMode:(int)aTrackingMode
	                   showSelectionForButton:(int)aBtnId
#else
-(UIButtonBar *)
createButtonBarSetDelegate:(id)aDelegate
	setBarStyle:(int)aBarStyle
	setButtonBarTrackingMode:(int)aTrackingMode
	showSelectionForButton:(int)aBtnId
#endif
{
	NSArray *buttonBarItems = [ self buttonBarItems ];
	if(buttonBarItems == nil || [buttonBarItems count] == 0) {
		return nil;
	}

#ifdef __BUILD_FOR_2_0__
	UIToolbar * buttonBar;
	buttonBar = [[UIToolbar alloc] initInView:self withFrame:[self makeButtonBarRect] withItemList:buttonBarItems];
#else
	UIButtonBar *buttonBar;
	//TODO use UITransitionView to hide/show bar dynamically 
	buttonBar = [ [ UIButtonBar alloc ]
	initInView: self
	//withFrame: CGRectMake(0.0f, 411.0f, 320.0f, 49.0f)	
	withFrame: [self makeButtonBarRect]//CGRectMake(0.0f, 460.0f - UI_BOTTOM_BUTTON_BAR_HEIGHT, 320.0f, UI_BOTTOM_BUTTON_BAR_HEIGHT)
	withItemList: buttonBarItems ];
#endif

	if(aDelegate != nil){
		[buttonBar setDelegate:aDelegate];
	}else{
		[buttonBar setDelegate:self];
	}
	[buttonBar setBarStyle:aBarStyle];
	[buttonBar setButtonBarTrackingMode: aTrackingMode];

	int buttonCount = [buttonBarItems count];
	//Create a int[] filled up with button ids
	int* buttons = malloc(sizeof(int) * buttonCount);
	int i;
	for(i = 0;i < buttonCount;i++) {
		buttons[i] = i+1;
	}
	//Register it
	[buttonBar registerButtonGroup:0 withButtons:buttons withCount: buttonCount];
	[buttonBar showButtonGroup: 0 withDuration: 0.0f];
	free(buttons);

	//Adjust the button size
	int tag;
	for(tag = 1; tag <= buttonCount; tag++) {
		[self _setButtonFrame:[buttonBar viewWithTag:tag] btnTag:tag];
		/*
		 [ [ buttonBar viewWithTag:tag ]
		 setFrame:CGRectMake(2.0f + ((tag - 1) * 64.0f), 1.0f, 64.0f, 48.0f)
		 ];
		 */
	}

	if(aBtnId > 0){
		[ buttonBar showSelectionForButton: aBtnId];	
	}


	return buttonBar;
}

-(void)setButtonEnabled:(int)buttonId enabled:(BOOL)flag{
	if(_buttonBar){
		[[_buttonBar viewWithTag:buttonId] setEnabled:flag];	
	}
}

-(BOOL)isButtonEnabled:(int)buttonId{
	if(_buttonBar){
		return 	[[_buttonBar viewWithTag:buttonId] isEnabled];
	}
        else {
           return NO;
        }
}

#ifdef __BUILD_FOR_2_0__
- (UIToolbar *)createButtonBar {
#else
- (UIButtonBar *)createButtonBar {
#endif
	// Create the button bar with default style
	return [self createButtonBarSetDelegate:self setBarStyle:1 setButtonBarTrackingMode:2 showSelectionForButton:1];
}

- (NSArray *)buttonBarItems {
	return nil;
}

- (void)buttonBarItemTapped:(id) sender {

}

- (void)reloadButtonBar {
	[ _buttonBar removeFromSuperview ];
	[ _buttonBar release ];
	_buttonBar = [ self createButtonBar ];
}

#ifdef __BUILD_FOR_2_0__
-(UIToolbar*)_buttonBar{
#else
-(UIButtonBar*)_buttonBar{
#endif
	return _buttonBar;
}

@end
