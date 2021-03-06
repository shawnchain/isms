/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import <UIKit/UIApplication.h>

@class NSTimer, SBDimmingWindow, SBUIController;

@interface SpringBoard : UIApplication
{
    SBUIController *_uiController;	// 12 = 0xc
    NSTimer *_menuButtonTimer;	// 16 = 0x10
    NSTimer *_lockButtonTimer;	// 20 = 0x14
    NSTimer *_idleTimer;	// 24 = 0x18
    NSTimer *_autoLockTimer;	// 28 = 0x1c
    double _lastTimeIdleCausedDim;	// 32 = 0x20
    double _headsetButtonDownTime;	// 40 = 0x28
    SBDimmingWindow *_simulatedBlankingWindow;	// 48 = 0x30
    unsigned int _headsetButtonClickCount;	// 52 = 0x34
    unsigned int _disableAutoDimming:1;	// 56 = 0x38
    unsigned int _nextLockUpLocks:1;	// 56 = 0x38
    unsigned int _poweringDown:1;	// 56 = 0x38
    unsigned int _autoDimmed:1;	// 56 = 0x38
    unsigned int _autoDimmedToBlack:1;	// 56 = 0x38
    unsigned int _powerManagementDisabled:1;	// 56 = 0x38
    unsigned int _powerManagementKeySet:1;	// 56 = 0x38
    unsigned int _ipodIsPlaying:1;	// 56 = 0x38
    int _UIOrientation;	// 60 = 0x3c
    BOOL _screenShooting;	// 64 = 0x40
}

- (void)ALSPrefsChanged:(id)fp8;	// IMP=0x00007714
- (int)UIOrientation;	// IMP=0x0000a034
- (void)_adjustMidnightTimerAfterSleep;	// IMP=0x00008ed4
- (void)_createLogFile;	// IMP=0x00005230
- (int)_frontMostAppOrientation;	// IMP=0x00009e90
- (void)_handleHeadsetButtonClick:(struct __GSEvent *)fp8;	// IMP=0x00007604
- (void)_killSpringBoardInResponseToCriticalWarning;	// IMP=0x00009e74
- (void)_launchIPod;	// IMP=0x00007f60
- (void)_menuButtonWasHeld;	// IMP=0x00006ad4
- (void)_midnightPassed;	// IMP=0x00008e68
- (unsigned int)_portForEvent:(struct __GSEvent *)fp8;	// IMP=0x00008304
- (void)_powerDownNow;	// IMP=0x00006f8c
- (void)_powerOn;	// IMP=0x00006f68
- (void)_receivedMemoryNotification;	// IMP=0x00009d38
- (void)_setMenuButtonTimer:(id)fp8;	// IMP=0x00006a78
- (void)_tearDownNow;	// IMP=0x0000a38c
- (void)_testPhoneAlerts;	// IMP=0x0000685c
- (void)_writeLogFile;	// IMP=0x0000534c
- (void)accessoryAvailabilityChanged:(struct __GSEvent *)fp8;	// IMP=0x000081e8
- (void)accessoryEvent:(struct __GSEvent *)fp8;	// IMP=0x000082e4
- (void)accessoryKeyStateChanged:(struct __GSEvent *)fp8;	// IMP=0x0000827c
- (int)alertOrientation;	// IMP=0x0000a338
- (void)appleIconViewRemoved;	// IMP=0x000059b0
- (void)applicationDidFinishLaunching:(id)fp8;	// IMP=0x000055b8
- (void)applicationExited:(struct __GSEvent *)fp8;	// IMP=0x00008444
- (void)applicationOpenURL:(id)fp8 asPanel:(BOOL)fp12;	// IMP=0x0000888c
- (void)applicationSuspend:(struct __GSEvent *)fp8;	// IMP=0x0000846c
- (void)applicationSuspended:(struct __GSEvent *)fp8;	// IMP=0x00008470
- (void)applicationSuspendedSettingsUpdated:(struct __GSEvent *)fp8;	// IMP=0x00008484
- (void)autoLock;	// IMP=0x00009480
- (void)autoLockPrefsChanged;	// IMP=0x00007c50
- (void)beginPowerDownCountDown;	// IMP=0x00006ed4
- (BOOL)canShowAlerts;	// IMP=0x0000a2c0
- (void)cancelTurnOffBacklightAfterDelay;	// IMP=0x00009054
- (void)clearIdleTimer;	// IMP=0x00009700
- (void)clockFormatChanged;	// IMP=0x00007bd0
- (void)didDismissMiniAlert;	// IMP=0x0000a220
- (void)didIdle;	// IMP=0x00009580
- (void)dim;	// IMP=0x00009014
- (void)dimToBlack;	// IMP=0x000092a8
- (void)frontDisplayDidChange:(id)fp8;	// IMP=0x0000a0f0
- (BOOL)handleEvent:(struct __GSEvent *)fp8;	// IMP=0x000054e4
- (void)handleOutOfLineDataRequest:(struct __GSEvent *)fp8;	// IMP=0x00009c88
- (void)handleOutOfLineDataResponse:(struct __GSEvent *)fp8;	// IMP=0x00008fa0
- (void)handleSpringboardURL:(id)fp8;	// IMP=0x00008498
- (void)headsetButtonDown:(struct __GSEvent *)fp8;	// IMP=0x000072f8
- (void)headsetButtonUp:(struct __GSEvent *)fp8;	// IMP=0x00007314
- (void)hideSimulatedScreenBlank;	// IMP=0x0000925c
- (BOOL)isLocked;	// IMP=0x0000a2fc
- (void)lockAfterCall;	// IMP=0x00009390
- (void)lockButtonDown:(struct __GSEvent *)fp8;	// IMP=0x00006d4c
- (void)lockButtonUp:(struct __GSEvent *)fp8;	// IMP=0x000070c8
- (void)lockDevice:(struct __GSEvent *)fp8;	// IMP=0x00009c8c
- (void)macWorldPrefsChanged:(BOOL)fp8;	// IMP=0x000079c8
- (void)menuButtonDown:(struct __GSEvent *)fp8;	// IMP=0x00006b38
- (void)menuButtonUp:(struct __GSEvent *)fp8;	// IMP=0x00006c30
- (double)nextIdleTimeDuration;	// IMP=0x000095c8
- (double)nextLockTimeDuration;	// IMP=0x00009640
- (void)noteUIOrientationChanged:(int)fp8 display:(id)fp12;	// IMP=0x00009e98
- (void)otherApplicationWillSuspend:(struct __GSEvent *)fp8;	// IMP=0x00008458
- (void)powerDown;	// IMP=0x00006fa0
- (void)powerDownCanceled:(id)fp8;	// IMP=0x00007080
- (void)powerDownRequested:(id)fp8;	// IMP=0x00007064
- (BOOL)powerManagementIsEnabled;	// IMP=0x00005d78
- (void)quitTopApplication:(struct __GSEvent *)fp8;	// IMP=0x0000840c
- (void)resetIdleDuration:(double)fp8;	// IMP=0x00009b70
- (void)resetIdleTimer;	// IMP=0x00009b50
- (void)resetIdleTimerAndUndim:(BOOL)fp8;	// IMP=0x00009764
- (void)ringerChanged:(int)fp8;	// IMP=0x0000a5c8
- (void)runFieldTestScript;	// IMP=0x000068d4
- (void)setBacklightFactor:(int)fp8;	// IMP=0x00008b44
- (void)setBacklightLevel:(float)fp8;	// IMP=0x00008b58
- (void)setProximitySensorEnabled:(int)fp8;	// IMP=0x00008b6c
- (void)setupMidnightTimer;	// IMP=0x00008b70
- (BOOL)shouldDimToBlackInsteadOfLock;	// IMP=0x00009444
- (BOOL)shouldRunFieldTestScript;	// IMP=0x00006a10
- (void)showEDGEActivationFailureAlert:(id)fp8;	// IMP=0x00005f80
- (void)showLowDiskSpaceAlert;	// IMP=0x00005f00
- (void)showSimulatedScreenBlank;	// IMP=0x00009150
- (void)showWiFiAlert;	// IMP=0x0000611c
- (void)significantTimeChange;	// IMP=0x00006904
- (void)statusBarEvent:(struct __GSEvent *)fp8;	// IMP=0x00009cd8
- (void)tearDown;	// IMP=0x0000a39c
- (void)tripleFingerGestureTriggered;	// IMP=0x0000699c
- (void)turnOffBacklight;	// IMP=0x00009040
- (void)turnOffBacklightAfterDelay;	// IMP=0x0000909c
- (void)undim;	// IMP=0x000092e4
- (void)updateAccelerometerSettings;	// IMP=0x0000a03c
- (void)updateIconVisibility:(BOOL)fp8;	// IMP=0x000077f4
- (void)updateRejectedInputSettings;	// IMP=0x00009c78
- (void)updateTouchPointSettings;	// IMP=0x0000a094
- (void)userDefaultsDidChange:(id)fp8;	// IMP=0x0000631c
- (void)userEventOccurred:(id)fp8;	// IMP=0x00009ad8
- (void)volumeChanged:(struct __GSEvent *)fp8;	// IMP=0x00008b24
- (void)wifiManager:(id)fp8 scanCompleted:(id)fp12;	// IMP=0x000061f0
- (void)willDismissMiniAlert:(int *)fp8 andShowAnother:(BOOL)fp12;	// IMP=0x0000a268
- (void)willDisplayMiniAlert:(int *)fp8;	// IMP=0x0000a224

@end

