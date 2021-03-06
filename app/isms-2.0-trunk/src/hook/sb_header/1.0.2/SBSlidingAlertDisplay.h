/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertDisplay.h"

@class SBDeviceLockKeypad, SBEmergencyCallView, TPLCDView, UIImageView, UIPasscodeField, UIView;

@interface SBSlidingAlertDisplay : SBAlertDisplay
{
    UIImageView *_backgroundView;	// 36 = 0x24
    UIView *_topBar;	// 40 = 0x28
    UIView *_bottomBar;	// 44 = 0x2c
    TPLCDView *_deviceLockStatusView;	// 48 = 0x30
    SBDeviceLockKeypad *_deviceLockKeypad;	// 52 = 0x34
    UIImageView *_deviceLockEntryBackground;	// 56 = 0x38
    UIPasscodeField *_deviceLockEntryField;	// 60 = 0x3c
    SBEmergencyCallView *_emergencyCallView;	// 64 = 0x40
    BOOL _playKeyboardClicks;	// 68 = 0x44
    unsigned int _animatingEmergencyCall:1;	// 69 = 0x45
    unsigned int _animatingIn:1;	// 69 = 0x45
    unsigned int _animatingOut:1;	// 69 = 0x45
    unsigned int _shouldFenceAnimations:1;	// 69 = 0x45
    unsigned int _showingDeviceLock:1;	// 69 = 0x45
    unsigned int _attemptingUnlock:1;	// 69 = 0x45
    unsigned int _showingDeviceUnlockFailure:1;	// 69 = 0x45
}

+ (id)createBottomBarForInstance:(id)fp8;	// IMP=0x00049114
+ (id)createTopBarForInstance:(id)fp8;	// IMP=0x00049088
+ (void)setDisplayPropertiesForActivationOfAlert:(id)fp8;	// IMP=0x0004911c
- (void)_animateToHidingDeviceLockFinished;	// IMP=0x0004af94
- (void)_animateToHidingOrShowingDeviceLockFinished;	// IMP=0x0004aefc
- (void)_animateToShowingDeviceLockFinished;	// IMP=0x0004af50
- (void)_animateView:(id)fp8 direction:(int)fp12;	// IMP=0x0004b650
- (void)_clearUnlockFailedIndicator;	// IMP=0x00049468
- (void)_enableEntry;	// IMP=0x0004b240
- (void)_entryFinishedWithPassword:(id)fp8;	// IMP=0x0004b368
- (struct CGRect)_entryFrame;	// IMP=0x0004a9b0
- (void)_fadeOutCompleted:(id)fp8;	// IMP=0x00049ca0
- (void)_resetStatusTextView;	// IMP=0x000493ac
- (void)_setTopBarImage:(id)fp8 shadowColor:(struct CGColor *)fp12;	// IMP=0x0004924c
- (void)_showUnlockFailedIndicator;	// IMP=0x000494c8
- (float)_startingKeypadXOrigin;	// IMP=0x0004aa50
- (void)alertDisplayWillBecomeVisible;	// IMP=0x0004a804
- (void)animateDisplayIn:(float)fp8 middleDelay:(float)fp12 animateStatusBar:(BOOL)fp16;	// IMP=0x0004a530
- (void)animateFromEmergencyCallWithDuration:(float)fp8;	// IMP=0x0004baa8
- (void)animateToEmergencyCall;	// IMP=0x0004b6d4
- (void)animateToShowingDeviceLock:(BOOL)fp8;	// IMP=0x0004ab08
- (void)beginAnimatingDisplayIn:(BOOL)fp8;	// IMP=0x0004a284
- (id)bottomBar;	// IMP=0x0004bdd0
- (void)dealloc;	// IMP=0x000496c8
- (void)deviceUnlockCanceled;	// IMP=0x0004b200
- (void)deviceUnlockFailed;	// IMP=0x0004b00c
- (void)deviceUnlockSucceeded;	// IMP=0x0004afd8
- (void)dismiss;	// IMP=0x00049dbc
- (float)durationForOthersActivation;	// IMP=0x00049db4
- (void)emergencyCallWasDisplayed;	// IMP=0x0004b9dc
- (void)emergencyCallWasRemoved;	// IMP=0x0004bcf0
- (void)finishedAnimatingIn;	// IMP=0x00049bc4
- (void)getFrameForTopButton:(struct CGRect *)fp8 bottomButton:(struct CGRect *)fp12;	// IMP=0x00049888
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00049578
- (BOOL)isAnimatingOut;	// IMP=0x00049c90
- (BOOL)isDisplayingErrorStatus;	// IMP=0x0004b308
- (BOOL)isReadyToBeRemovedFromView;	// IMP=0x00049da0
- (BOOL)isShowingDeviceLock;	// IMP=0x0004a9a0
- (id)lockBar;	// IMP=0x00049770
- (struct CGRect)middleFrame;	// IMP=0x000497c8
- (void)passcodeFieldDidAcceptEntry:(id)fp8;	// IMP=0x0004b64c
- (void)performAnimateDisplayIn;	// IMP=0x0004a498
- (void)phonePad:(id)fp8 keyDown:(BOOL)fp12;	// IMP=0x0004b3bc
- (void)phonePad:(id)fp8 keyUp:(BOOL)fp12;	// IMP=0x0004b3ec
- (void)removeBlockedStatus;	// IMP=0x0004b2d4
- (void)setMiddleContentAlpha:(float)fp8;	// IMP=0x00049d80
- (void)setShouldFenceAnimations:(BOOL)fp8;	// IMP=0x0004a988
- (void)setShowingDeviceLock:(BOOL)fp8;	// IMP=0x0004aae4
- (void)setShowingDeviceLock:(BOOL)fp8 duration:(float)fp12;	// IMP=0x0004bde0
- (BOOL)shouldAnimateIconsIn;	// IMP=0x00049c40
- (BOOL)shouldAnimateIconsOut;	// IMP=0x00049c88
- (BOOL)shouldShowBlockedRedStatus;	// IMP=0x0004b290
- (void)showBlockedStatus;	// IMP=0x0004b298
- (BOOL)showsDesktopImage;	// IMP=0x00049a28
- (id)topBar;	// IMP=0x0004bdd8
- (void)updateDesktopImage:(id)fp8;	// IMP=0x00049a30

@end

