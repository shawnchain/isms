/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBSlidingAlertDisplay.h"

@class NSDictionary, NSString, NSTimer, SBActivationView, SBAwayChargingView, SBAwayDateView, SBAwayInCallController, SBAwayItemsView, SBNowPlayingArtView, TPBottomButtonBar, TPBottomLockBar, UIAlertSheet, UIImage, UIPushButton;

@interface SBAwayView : SBSlidingAlertDisplay
{
    BOOL _isDimmed;	// 70 = 0x46
    BOOL _deferAwayItemFetching;	// 71 = 0x47
    BOOL _showingBlockedIndicator;	// 72 = 0x48
    SBAwayChargingView *_chargingView;	// 76 = 0x4c
    SBAwayDateView *_dateView;	// 80 = 0x50
    SBNowPlayingArtView *_albumArtView;	// 84 = 0x54
    SBAwayItemsView *_awayItemsView;	// 88 = 0x58
    SBActivationView *_activationView;	// 92 = 0x5c
    NSTimer *_mediaControlsTimer;	// 96 = 0x60
    UIImage *_controlsLCDBG;	// 100 = 0x64
    UIImage *_priorLCDBG;	// 104 = 0x68
    NSDictionary *_nowPlayingInfo;	// 108 = 0x6c
    UIImage *_nowPlayingArt;	// 112 = 0x70
    NSString *_lastTrackArtPath;	// 116 = 0x74
    NSTimer *_blockedStatusUpdateTimer;	// 120 = 0x78
    UIAlertSheet *_alertSheet;	// 124 = 0x7c
    SBAwayInCallController *_inCallController;	// 128 = 0x80
    TPBottomLockBar *_lockBar;	// 132 = 0x84
    TPBottomButtonBar *_cancelSyncBar;	// 136 = 0x88
    UIPushButton *_infoButton;	// 140 = 0x8c
}

+ (id)createBottomBarForInstance:(id)fp8;	// IMP=0x000343f4
+ (id)lockLabel:(BOOL)fp8 fontSize:(float *)fp12;	// IMP=0x000345e4
- (void)_batteryStatusChanged:(id)fp8;	// IMP=0x00036d80
- (void)_clearBlockedStatusUpdateTimer;	// IMP=0x00034698
- (void)_positionAwayItemsView;	// IMP=0x000366a0
- (void)_postLockCompletedNotification;	// IMP=0x00034a3c
- (void)_updateBlockedStatus;	// IMP=0x000363f4
- (void)_updateBlockedStatusLabel;	// IMP=0x00035ea4
- (void)addChargingView;	// IMP=0x00036f2c
- (void)addDateView;	// IMP=0x00036540
- (void)animateToShowingDeviceLock:(BOOL)fp8;	// IMP=0x00037a14
- (id)chargingView;	// IMP=0x00036dcc
- (void)clearMediaControlsTimer;	// IMP=0x00036f90
- (id)dateView;	// IMP=0x0003647c
- (void)dealloc;	// IMP=0x000348bc
- (void)dismiss;	// IMP=0x00034acc
- (void)finishedAnimatingIn;	// IMP=0x00034a5c
- (void)handleRequestedAlbumArtBytes:(char *)fp8 length:(unsigned int)fp12;	// IMP=0x00037844
- (BOOL)hasAwayItems;	// IMP=0x00036934
- (void)hideAwayItems;	// IMP=0x00036814
- (void)hideChargingView;	// IMP=0x00036f6c
- (void)hideInfoButton;	// IMP=0x00034e94
- (void)hideMediaControls;	// IMP=0x0003705c
- (void)hideNowPlaying;	// IMP=0x000373c4
- (void)hideSyncingBottomBar:(BOOL)fp8;	// IMP=0x0003734c
- (id)inCallController;	// IMP=0x000365d0
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x000346d8
- (BOOL)isShowingMediaControls;	// IMP=0x000371e8
- (void)lockBarStartedTracking:(id)fp8;	// IMP=0x00035b70
- (void)lockBarStoppedTracking:(id)fp8;	// IMP=0x00035bb0
- (void)lockBarUnlocked:(id)fp8;	// IMP=0x00035ae4
- (void)musicPlayerDied:(id)fp8;	// IMP=0x00037504
- (id)nowPlayingArtView;	// IMP=0x000373e8
- (void)postLockCompletedNotification:(BOOL)fp8;	// IMP=0x00034858
- (void)removeAlertSheet;	// IMP=0x00036bbc
- (void)removeBlockedStatus;	// IMP=0x000362ec
- (void)removeDateView;	// IMP=0x0003651c
- (void)restartMediaControlsTimer;	// IMP=0x00036fd8
- (void)setBottomLockBar:(id)fp8;	// IMP=0x00034b50
- (void)setDimmed:(BOOL)fp8;	// IMP=0x00035968
- (void)setDrawsBlackBackground:(BOOL)fp8;	// IMP=0x00035a94
- (void)setMiddleContentAlpha:(float)fp8;	// IMP=0x000358ec
- (void)setShowingDeviceLock:(BOOL)fp8 duration:(float)fp12;	// IMP=0x00036958
- (BOOL)shouldAnimateIn;	// IMP=0x00034b98
- (BOOL)shouldShowBlockedRedStatus;	// IMP=0x00035e28
- (BOOL)shouldShowInCallInfo;	// IMP=0x00036640
- (void)showAlertSheet:(id)fp8;	// IMP=0x00036a5c
- (void)showAwayItems;	// IMP=0x00036844
- (void)showBlockedStatus;	// IMP=0x00036288
- (void)showInfoButton;	// IMP=0x00034c78
- (void)showMediaControls;	// IMP=0x00037a6c
- (void)showSyncingBottomBar:(BOOL)fp8;	// IMP=0x0003720c
- (void)slideAlertSheetOut:(BOOL)fp8 direction:(BOOL)fp12 duration:(float)fp16;	// IMP=0x00036c10
- (void)startAnimations;	// IMP=0x00034ba0
- (void)stopAnimations;	// IMP=0x00034be4
- (void)toggleMediaControls;	// IMP=0x000371a0
- (void)updateInCallInfo;	// IMP=0x00036684
- (void)updateInterface;	// IMP=0x00034eb4
- (void)updateLockBarLabel;	// IMP=0x00035bec
- (BOOL)updateNowPlayingArt;	// IMP=0x000376b0
- (void)updateNowPlayingInfo:(id)fp8;	// IMP=0x00037524

@end

