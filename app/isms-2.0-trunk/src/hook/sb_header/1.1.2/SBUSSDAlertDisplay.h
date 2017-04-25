/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertDisplay.h"

@class SBTextDisplayView, TPBottomButtonBar, UIProgressIndicator, UIScroller, UITextField, UITransitionView, UIView;

@interface SBUSSDAlertDisplay : SBAlertDisplay
{
    TPBottomButtonBar *_responseBar;	// 36 = 0x24
    UIView *_notifyView;	// 40 = 0x28
    UIView *_replyView;	// 44 = 0x2c
    UITransitionView *_transitionView;	// 48 = 0x30
    UIScroller *_scroller;	// 52 = 0x34
    UIView *_contentView;	// 56 = 0x38
    SBTextDisplayView *_charsRemainingView;	// 60 = 0x3c
    UIProgressIndicator *_progressIndicator;	// 64 = 0x40
    UITextField *_responseField;	// 68 = 0x44
    BOOL _allowsResponse;	// 72 = 0x48
}

- (void)_cancelClicked;	// IMP=0x00032f40
- (id)_notifyView;	// IMP=0x00032a00
- (void)_okayClicked;	// IMP=0x00032ed0
- (void)_replyClicked;	// IMP=0x000333d8
- (id)_replyView;	// IMP=0x00032aa0
- (void)_setupResponseBar;	// IMP=0x00033f60
- (void)_textChanged:(id)fp8;	// IMP=0x00032eb4
- (void)_updateCharsRemaining;	// IMP=0x00032d84
- (void)alertDisplayBecameVisible;	// IMP=0x00032c7c
- (void)alertDisplayWillBecomeVisible;	// IMP=0x00034314
- (void)alertStringAvailable:(id)fp8;	// IMP=0x00032c9c
- (BOOL)allowsResponse;	// IMP=0x00032d20
- (void)dealloc;	// IMP=0x00032b98
- (void)displayString:(id)fp8 centerVertically:(BOOL)fp12;	// IMP=0x00033680
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00032874
- (void)navigationBar:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x00032f68
- (void)setAllowsResponse:(BOOL)fp8;	// IMP=0x000339fc
- (BOOL)textField:(id)fp8 shouldInsertText:(id)fp12 replacingRange:(struct _NSRange)fp16;	// IMP=0x00032d28

@end
