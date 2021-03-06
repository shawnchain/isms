/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBSlidingAlertDisplay.h"

@interface SBCallAlertDisplay : SBSlidingAlertDisplay
{
    BOOL _wasToldToStopRinging;	// 70 = 0x46
    BOOL _answered;	// 71 = 0x47
}

+ (id)createBottomBarForInstance:(id)fp8;	// IMP=0x0001b0a4
+ (id)createBottomLockBarForDisplay:(id)fp8;	// IMP=0x0001a068
- (void)_ringIfNecessary;	// IMP=0x0001a7ec
- (id)additionalURLParameter;	// IMP=0x0001a9f0
- (void)alertDisplayBecameVisible;	// IMP=0x0001a980
- (void)alertDisplayWillBecomeVisible;	// IMP=0x0001a89c
- (void)answer:(id)fp8;	// IMP=0x0001aad0
- (void)answerAndRelease;	// IMP=0x0001aa88
- (void)answerCall:(struct __CTCall *)fp8;	// IMP=0x0001a9fc
- (void)checkForStatusChange;	// IMP=0x0001a6e4
- (void)dealloc;	// IMP=0x0001a1d0
- (void)dismiss;	// IMP=0x0001ae44
- (void)finishedAnimatingIn;	// IMP=0x0001a99c
- (void)handleVolumeEvent:(struct __GSEvent *)fp8;	// IMP=0x0001b060
- (void)ignore;	// IMP=0x0001af20
- (void)ignoreAndRelease;	// IMP=0x0001aedc
- (void)lockBarUnlocked:(id)fp8;	// IMP=0x0001ae28
- (void)ringOrVibrate;	// IMP=0x0001a220
- (void)ringerChanged;	// IMP=0x0001a334
- (void)setAlert:(id)fp8;	// IMP=0x0001a4e4
- (void)stopRingingOrVibrating;	// IMP=0x0001a29c
- (void)updateImageFromPerson:(struct CPRecord *)fp8;	// IMP=0x0001a470
- (void)updateLCDWithName:(id)fp8 label:(id)fp12 breakPoint:(unsigned int)fp16;	// IMP=0x0001a360
- (BOOL)wasToldToStopRinging;	// IMP=0x0001a32c

@end

