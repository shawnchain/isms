/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class SBApplication, UIWindow;

@interface SBMiniAlertController : NSObject
{
    SBApplication *_displayShowingAnAlert;	// 4 = 0x4
    UIWindow *_dimmingWindow;	// 8 = 0x8
    unsigned int _dontAskApps:1;	// 12 = 0xc
    unsigned int _reserved:31;	// 12 = 0xc
}

+ (id)sharedInstance;	// IMP=0x0006628c
- (BOOL)canShowAlerts;	// IMP=0x00066d40
- (void)cancelHideDimmingWindow;	// IMP=0x00066670
- (void)deactivateAlertItemsWithBundleIdentifier:(id)fp8;	// IMP=0x0006680c
- (id)dimImageForKeyboard:(BOOL)fp8;	// IMP=0x000662dc
- (void)displayDidDisableMiniAlerts:(id)fp8;	// IMP=0x00066a74
- (id)displayShowingAnAlert;	// IMP=0x00066938
- (void)displayWillDismissMiniAlert:(id)fp8 andShowAnother:(BOOL)fp12;	// IMP=0x00066958
- (void)displayWillShowMiniAlert:(id)fp8;	// IMP=0x0006687c
- (void)finishedAnimatingDimWindowOut:(id)fp8 didFinish:(id)fp12;	// IMP=0x000665e0
- (void)hideApplicationMiniAlerts;	// IMP=0x00066bb4
- (void)hideDimmingWindow;	// IMP=0x000666fc
- (void)hideDimmingWindowAfterDelay;	// IMP=0x000666b8
- (void)noteMiniAlertStateChanged;	// IMP=0x00066c38
- (void)setShouldAskApps:(BOOL)fp8;	// IMP=0x00066940
- (void)showApplicationMiniAlertsIfNeeded;	// IMP=0x00066ac8
- (void)showDimmingWindow;	// IMP=0x000663f0

@end
