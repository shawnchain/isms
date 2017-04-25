/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertDisplay.h"

@class NSTimer, SBPowerDownController, TPBottomButtonBar, TPTopLockBar, UIView;

@interface SBPowerDownView : SBAlertDisplay
{
    UIView *_dimView;	// 36 = 0x24
    TPTopLockBar *_lockView;	// 40 = 0x28
    TPBottomButtonBar *_cancelView;	// 44 = 0x2c
    SBPowerDownController *_powerDownController;	// 48 = 0x30
    NSTimer *_autoDismissTimer;	// 52 = 0x34
}

- (void)animateDark;	// IMP=0x00040348
- (void)animateIn;	// IMP=0x0003ff2c
- (void)animateOut;	// IMP=0x00040160
- (void)cancel:(id)fp8;	// IMP=0x0003fdf0
- (void)cancelAutoDismissTimer;	// IMP=0x0003fd2c
- (void)dealloc;	// IMP=0x0003fcb0
- (void)finishedAnimatingIn;	// IMP=0x0003feb8
- (void)finishedAnimatingOut;	// IMP=0x0003fef0
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0003f860
- (void)lockBarStartedTracking:(id)fp8;	// IMP=0x0003fe58
- (void)lockBarStoppedTracking:(id)fp8;	// IMP=0x0003fe74
- (void)lockBarUnlocked:(id)fp8;	// IMP=0x0003fe24
- (void)notifyDelegateOfPowerDown;	// IMP=0x0003ff0c
- (void)powerDown:(id)fp8;	// IMP=0x0003fe90
- (void)resetAutoDismissTimer;	// IMP=0x0003fd6c
- (void)setPowerDownController:(id)fp8;	// IMP=0x0003feb0

@end
