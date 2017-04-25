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

#import "Prefix.h"
#import "UIController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITransitionView.h>

#import "TransitionAware.h"  

#ifdef __BUILD_FOR_2_0__
#else
#import <LayerKit/LayerKit.h>
#endif

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Geometry.h>
#import <QuartzCore/QuartzCore.h>
#endif

static UIController* defaultInstance = nil;
static NSMutableDictionary* instanceMap = nil;

@interface DummyView : UIView
-(id)initWithFrame:(CGRect)frame;
@end
@implementation DummyView : UIView
-(void)didShow:(NSDictionary*)param{
	DBG(@"DummyView remove from superview");
	[self removeFromSuperview];
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
	[self setUserInteractionEnabled:YES];
	return self;
}
@end

/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIController

+(id)initDefaultControllerWithTransitionView:(UITransitionView*) tview withDefaultView:(UIView*) dview{
	if(defaultInstance != nil){
		LOG(@"WARN - Default Controller has already been initialized!");
		// Already initialized ?
		return nil;
	}
	defaultInstance = [[self alloc] initWithTransitionView:tview withDefaultView:dview];
	[defaultInstance setName:@"default"];
	return defaultInstance;
}

+(void)initWithDefaultController:(UIController*) aController{
	if(defaultInstance != nil){
		LOG(@"WARN - Default Controller has already been initialized!");
		// Already initialized ?
		return;
	}
	defaultInstance = [aController retain];
}

+(void)registerController:(UIController*) aController forName:(NSString*)name{
	if(instanceMap == nil){
		instanceMap = [[NSMutableDictionary alloc] init];
	}
	if([instanceMap objectForKey:name]){
		LOG(@"WARN - Already have a controller registered by name %@",name);
		//[instanceMap removeObjectForKey:name];
		//DECIDE replace the old one or just return ?
	}
	[aController setName:name];
	[instanceMap setObject:aController forKey:name];
}

+(void)release{
	if(instanceMap){
		[instanceMap release];
		instanceMap = nil;
	}
	if(defaultInstance){
		[defaultInstance release];
		defaultInstance = nil;
	}
}

+(UIController*) controllerForName:(NSString*)name{
	if(name == nil){
		return defaultInstance;
	}
	return [instanceMap objectForKey:name];
}

+(UIController*) defaultController{
	return defaultInstance;
}

+(UIController*)rootController{
	return defaultInstance;
}

-(id)initWithDefaultView:(UIView*)aView{
	CGRect rect = [aView bounds];
	UITransitionView *tView = [[UITransitionView alloc]initWithFrame:rect];
	[self initWithTransitionView:tView withDefaultView:aView];
	[tView release];
	return self;
}

-(id)initWithTransitionView:(UITransitionView*)tView withDefaultView:(UIView*) dView{	
	self = [super init];
	if(self == nil) {
		return nil;
	}
	if(tView == nil){
		LOG(@"ERROR - transitionView is null");
		return nil;
	}
	if(dView == nil){
		LOG(@"ERROR - defaultView is null");
		return nil;
	}
	
	CGRect rect = [tView bounds];
		
	//TODO assert that view should not be nill
	RETAIN(transitionView, tView);
	[transitionView setDelegate:self]; // Get notified when transition is done
	
	RETAIN(defaultView, dView);
	dummyView = [[UIView alloc] initWithFrame:rect];
	// Create the mask view
	maskView = [[DummyView alloc] initWithFrame:rect];

	currentView = nil;
	viewArray = [[NSMutableArray alloc] init];
	styleArray = [[NSMutableArray alloc] init];
	//transitionViewArray = [[NSMutableArray alloc] init];
	return self;
}

// Callback by UITransitionView when transition is done
- (void)transitionViewDidComplete:(UITransitionView*)view fromView:(UIView*)from toView:(UIView*)to {
	//FIXME should store the value
	if(to != nil){
		currentView = to;
		LOG(@">>>UIController(%@) currentView is changed to: %@",name,to);
		[self _afterTransitionFrom:from to:to withParam:nil];		
	}else{
		LOG(@">>>WARNING - UIController(%@) transition to NULL view??? currentView: %@",name,currentView);
	}
}

//- (void)transitionViewDidComplete:(UITransitionView*)view finished:(BOOL)flag{
//	LOG(@">>>UIController(%@) - transitionViewDidComplete - %@ / %d",name,view,flag);
//}

//- (void)transitionViewDidComplete:(UITransitionView*)view{
//	LOG(@">>>UIController(%@) - transitionViewDidComplete - %@",name,view);
//}

- (void)dealloc{
	RELEASE(viewArray);
	RELEASE(styleArray);
	RELEASE(transitionView);
	RELEASE(defaultView);
	RELEASE(name);
	RELEASE(dummyView);
	RELEASE(maskView);
	//RELEASE(transitionViewArray);
	[super dealloc];
}

-(void) _flipView:(UIView*) aView withStyle:(int)style {
	NSString* animationType = nil;
	NSString* animationSubType = nil;

#ifdef __BUILD_FOR_2_0__
	if(style == UITransitionFlipRight) {
		animationType = @"oglFlip";
		animationSubType = kCATransitionFromRight;
	} else if(style == UITransitionFlipLeft) {
		animationType = @"oglFlip";
		animationSubType = kCATransitionFromLeft;
	} else if(style == UITransitionZoomIn){
		animationType = @"zoomyIn";
		animationSubType = @"";		
	}else if(style == UITransitionZoomOut){
		animationType = @"zoomyOut";
		animationSubType = @"";
	}
#else
	if(style == UITransitionFlipRight) {
		animationType = @"oglFlip";
		animationSubType = @"fromRight";
	} else if(style == UITransitionFlipLeft) {
		animationType = @"oglFlip";
		animationSubType = @"fromLeft";
	} else if(style == UITransitionZoomIn){
		animationType = @"zoomyIn";
		animationSubType = @"";		
	}else if(style == UITransitionZoomOut){
		animationType = @"zoomyOut";
		animationSubType = @"";
	}
#endif
	if(animationType == nil || animationSubType == nil) {
		//Unknow type ?
		//LOG(@"Unknow flip style %d,style");
		return;
	}

#ifdef __BUILD_FOR_2_0__
	CATransition * animation = [CATransition animation];
#else
	LKAnimation *animation = [LKTransition animation];
#endif
	[animation setType: animationType];
	[animation setSubtype:animationSubType];
#ifdef __BUILD_FOR_2_0__
	[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[animation setFillMode:kCAFillModeForwards];
	[animation setDuration:0.8]; // 8 * 0.35 = 2.8

	[[aView layer] addAnimation: animation forKey:0];
#else
	[animation setTimingFunction: [LKTimingFunction functionWithName: @"easeInEaseOut"]];
	[animation setFillMode: @"extended"];
	[animation setTransitionFlags: 3];
	[animation setDuration: 8]; // 8 * 0.35 = 2.8
	[animation setSpeed:0.35f];

	[[aView _layer] addAnimation: animation forKey: 0];
#endif
	
        // Can we release it?
	//[animation release];
}

//DEPRECATED
-(void)flipView:(int)style{
	[self _flipView:transitionView withStyle:style];
}

-(int)getOppositeStyle:(int)inValue{
	switch (inValue) {
	case UITransitionShiftLeft: {
		return UITransitionShiftRight;
	}
	case UITransitionShiftRight: {
		return UITransitionShiftLeft;
	}
	case UITransitionShiftUp: {
		return UITransitionShiftDown;
	}
	case UITransitionShiftDown: {
		return UITransitionShiftUp;
	}
	case UITransitionFlipLeft: {
		return UITransitionFlipRight;
	}
	case UITransitionFlipRight: {
		return UITransitionFlipLeft;
	}
	case UITransitionZoomOut:{
		return UITransitionZoomIn;
	}
	case UITransitionZoomIn:{
		return UITransitionZoomOut;
	}
	default:
		return inValue;
	}
}

-(BOOL) _beforeTransitionFrom:(id) fromView to:(id) toView withParam:(NSMutableDictionary*) param{
	//FIXME willHide will never be called if we're using the maskView
	//NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
	if(fromView != nil && [fromView respondsToSelector:@selector(willHide:)]){
		LOG(@"UIController(%@) - Call %@.willHide",name,[fromView class]);
		if(![fromView willHide:param]){
			return NO;
		}
	}
	if(toView != nil && [toView respondsToSelector:@selector(willShow:)]){
		LOG(@"UIController(%@) - Call %@.willShow",name,[toView class]);
		if(![toView willShow:param]){
			return NO;
		};
	}
	return YES;
	//[param release];
}

-(void) _afterTransitionFrom:(id) fromView to:(id) toView withParam:(NSMutableDictionary*) param{
	//NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
	if(fromView != nil&& [fromView respondsToSelector:@selector(didHide:)]){
		LOG(@"UIController(%@) - Call %@.didHide",name,[fromView class]);
		[fromView didHide:param];
	}
	if(toView != nil && [toView respondsToSelector:@selector(didShow:)]){
		LOG(@"UIController(%@) - Call %@.didShow",name,[toView class]);
		[toView didShow:param];
	}

	//[param release];
}

/**
 * Show a view, no state will be recorded
 */
-(void)showView:(UIView*)aView withStyle:(int)aStyle withParam:(NSMutableDictionary*) param{
	if(aView == nil){
		return;
	}
	if(currentView == aView){
		LOG(@"Current view(%@) = target view(%@), showView aborted!",currentView, aView);
		return;
	}
	if([self _beforeTransitionFrom:currentView to:aView withParam:param]){
		LOG(@"UIController(%@) - Show view %@(0x%@)",name,[aView class],aView);
		[transitionView transition:aStyle fromView:currentView toView:aView];
//		UIView* prevView = currentView;
//		currentView = aView;
//		[self _afterTransitionFrom:prevView to:aView withParam:param];
	}
}

-(void)showView:(UIView*)aView withStyle:(int)aStyle{
	[self showView:aView withStyle:aStyle withParam:nil];
}

-(void)showView:(UIView*)aView{
	[self showView:aView withStyle:0 withParam:nil];
}

// Currently no parameter is availble
-(void)showDefaultViewWithStyle:(int)aStyle{
	if(currentView == nil){
		// We're first running this method ?
		[self showView:dummyView];	
	}
	[self showView:defaultView withStyle:aStyle];
}

-(void) _performTransitionOnMainThread:(id)target transType:(int)type fromView:(id)from toView:(id)to delay:(float)delay{
	SEL sel = @selector(transition:fromView:toView:);
	NSMethodSignature* sig  = [target methodSignatureForSelector: sel];
	if(!sig){
		ERROR(@"Method signature not found! %@",sel);
	}
	
	NSInvocation* invocation = [NSInvocation 
								invocationWithMethodSignature: sig];
	
	[invocation setTarget: target];
	[invocation setSelector: sel];
	[invocation setArgument:&type atIndex:2];
	[invocation setArgument:&from atIndex:3];
	[invocation setArgument:&to atIndex:4];
	
	[invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
	
	//[invocation performSelectorOnMainThread: @selector(invoke) withObject: nil waitUntilDone:YES];
	
	//void* result = malloc([methodSignature methodReturnLength]); // TODO
	//[invocation getReturnValue: result];
	//NSLog(@"performSelectorOnMainThread returning %@", result);
}


-(void)switchToView:(UIView*)toView from:(UIView*)fromView withStyle:(int) aStyle withParam:(NSMutableDictionary*)param{
	if(currentView == toView){
		LOG(@"Current view = target view, showView aborted!");
		return;
	}
	if(toView == nil){
		return;
	}
	if(param == nil){
		param = [NSMutableDictionary dictionary];
	}
	if(fromView != nil){
		[param setObject:fromView forKey:@"fromView"];
		[viewArray addObject:fromView];
	}else{
		[viewArray addObject:defaultView];
	}
	NSNumber *nStyle = [NSNumber numberWithInt:aStyle];
	[param setObject:nStyle forKey:@"fromStyle"];
	[styleArray addObject:nStyle];
	LOG(@"UIController(%@) - View switch from %@ to %@, style: %d",name, [fromView class],[toView class],aStyle);
	if(![self _beforeTransitionFrom:fromView to:toView withParam:param]){
		// view refused to be hide ?
		return;
	}
	if(aStyle & UITransitionFlip) {
		[self flipView:aStyle];
		[transitionView transition:UITransitionShiftImmediate fromView:fromView toView:toView];
		//[self _performTransitionOnMainThread:transitionView transType:UITransitionShiftImmediate fromView:fromView toView:toView delay:0.5];

	} else {
		[transitionView transition:aStyle fromView:fromView toView:toView];
	}
	//after transition -- Will do in the callback
//	currentView = toView;
//	[self _afterTransitionFrom:fromView to:toView withParam:param];
}

-(void)switchToView:(UIView*)toView from:(UIView*)fromView withStyle:(int) aStyle {
	[self switchToView:toView from:fromView withStyle:aStyle withParam:nil];
}

-(void)switchToView:(UIView*)toView from:(UIView*)fromView withParam:(NSMutableDictionary*)param{
	[self switchToView:toView from:fromView withStyle:0 withParam:param];
}

-(void)switchToView:(UIView*)toView from:(UIView*)fromView{
	[self switchToView:toView from:fromView withStyle:0 withParam:nil];
}

-(void)switchToView:(UIView*)toView withParam:(NSMutableDictionary*)param{
	[self switchToView:toView from:nil withStyle:0 withParam:param];
}

-(void)switchToView:(UIView*)toView{
	[self switchToView:toView from:nil withStyle:0 withParam:nil];
}


-(void)switchBackFrom:(UIView*)fromView withParam:(NSMutableDictionary*) param{

	if([viewArray count] == 0) {
		if(currentView == defaultView){
			LOG(@"Current view(%@) = target view(%@), switchBackFromView aborted!",currentView,defaultView);
			return;
		}
		// No history, simply swich to the default view, with no effect
		//before transition
		if([self _beforeTransitionFrom:fromView to:defaultView withParam:param]){
			[transitionView transition:0 fromView:fromView toView:defaultView];
			
			//[self _afterTransitionFrom:fromView to:defaultView withParam:param];
			//currentView = defaultView;
		}
		return;
	}

	UIView* toView = [viewArray lastObject];
	if(currentView == toView){
		LOG(@"Current view(%@) = target view(%@), switchBackFromView aborted!",currentView,toView);
		return;
	}
	int style = [self getOppositeStyle:[[styleArray lastObject] intValue]];
	//LOG1(@"Transition style: %d",style);
	LOG(@"UIController(%@) - Will Transition from %@ to %@, style: %d",name,[fromView class],[toView class],style);
	//before transition
	if(![self _beforeTransitionFrom:fromView to:toView withParam:param]){
		// View refused to hide ?
		return;
	}
	if(style & UITransitionFlip) {
		[self flipView:style];
		//in 2.x we need to wait for the animation to complete
		//[self performSelector:@selector(sendNext) withObject:nil afterDelay:delay];
		//[self _performTransitionOnMainThread:transitionView transType:UITransitionShiftImmediate fromView:fromView toView:toView delay:0.5];
		[transitionView transition:UITransitionShiftImmediate fromView:fromView toView:toView];
	} else {
		[transitionView transition:style fromView:fromView toView:toView];
	}
	//after transition
//	currentView = toView;
//	[self _afterTransitionFrom:fromView to:toView withParam:param];
	// Popup the state
	[viewArray removeLastObject];
	[styleArray removeLastObject];
	//[transitionViewArray removeLastObject];	
}

-(void)switchBackFrom:(UIView*)fromView{
	[self switchBackFrom:fromView withParam:nil];
}

-(void)switchBackWithParam:(NSMutableDictionary*) param{
	[self switchBackFrom:nil withParam:param];
}

-(void)switchBack{
	[self switchBackFrom:nil withParam:nil];
}

-(void)refreshCurrentView{
//	if(currentView && [currentView respondsToSelector:@selector(refresh)]){
//		[currentView refresh];
//	}
	LOG(@"Refreshing current view %@",currentView);
	if(currentView && [currentView respondsToSelector:@selector(reloadData)]){
		[currentView reloadData];
	}
	
	if(currentView && [currentView respondsToSelector:@selector(willShow:)]){
		if(![currentView willShow:nil]){
			return;
		}
	}
	
	if(currentView && [currentView respondsToSelector:@selector(didShow:)]){
		[currentView didShow:nil];
	}
}

-(void)clearAllState {
	[viewArray removeAllObjects];
	[styleArray removeAllObjects];
	currentView = nil;
	//[transitionViewArray removeAllObjects];
}

-(UIView*)currentView{
	return currentView;
}

-(UITransitionView*)transitionView{
	return transitionView;
}

-(UIView*)defaultView{
	return defaultView;
}

-(UIView*)maskView{
	return maskView;
}

-(void)_setCurrentView:(UIView*)aView{
	// Weak reference
	currentView = aView;
}

-(NSString*)name{
	return name;
}

-(void)setName:(NSString*)value{
	RETAIN(name,value);
}

@end
