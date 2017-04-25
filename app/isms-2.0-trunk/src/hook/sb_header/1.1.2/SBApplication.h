/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBDisplay.h"

@class NSMutableArray, NSMutableSet, NSString, UIRemoteApplication;

@interface SBApplication : SBDisplay
{
    NSString *_roleID;	// 36 = 0x24
    NSString *_path;	// 40 = 0x28
    NSString *_bundleID;	// 44 = 0x2c
    BOOL _isLaunching;	// 48 = 0x30
    int _failedLaunchCount;	// 52 = 0x34
    int _memoryWarningCount;	// 56 = 0x38
    BOOL _enabled;	// 60 = 0x3c
    BOOL _useDemoRole;	// 61 = 0x3d
    unsigned int _dataUsage:4;	// 62 = 0x3e
    unsigned int _relauchesOnAbnormalExit:1;	// 62 = 0x3e
    unsigned int _isDefaultRole:1;	// 62 = 0x3e
    NSString *_demoRole;	// 64 = 0x40
    NSMutableSet *_statusBarItemSet;	// 68 = 0x44
    NSMutableArray *_tags;	// 72 = 0x48
    UIRemoteApplication *_remoteApplication;	// 76 = 0x4c
    struct __CFSet *_launchAlerts;	// 80 = 0x50
    int _pid;	// 84 = 0x54
    NSString *_displayName;	// 88 = 0x58
}

+ (id)applicationWithDisplayIdentifier:(id)fp8;	// IMP=0x0001edbc
+ (id)applicationWithPath:(id)fp8;	// IMP=0x0001e950
+ (id)applicationWithPath:(id)fp8 roleID:(id)fp12;	// IMP=0x0001e970
+ (id)applicationWithPath:(id)fp8 roleID:(id)fp12 plist:(id)fp16;	// IMP=0x0001e9bc
+ (id)applicationsByRoleWithPath:(id)fp8;	// IMP=0x0001e7e0
+ (void)flushLaunchAlertsOfType:(int)fp8;	// IMP=0x00021cc0
+ (void)flushSnapshotsForIdentifier:(id)fp8;	// IMP=0x0001facc
+ (id)iPod;	// IMP=0x0001ef88
+ (void)setUseDemoRole:(BOOL)fp8;	// IMP=0x0001f00c
+ (id)springBoard;	// IMP=0x0001ef08
- (int)PID;	// IMP=0x000219c8
- (id)_additionalDisplayQualification;	// IMP=0x0001f888
- (void)_autoLaunchMailIfNeeded;	// IMP=0x00021268
- (void)_cancelWatchdogTimer;	// IMP=0x0001f58c
- (void)_relaunchAfterAbnormalExit;	// IMP=0x0002127c
- (void)_sendCurrentDeviceOrientation;	// IMP=0x0001ffa4
- (void)_startDeactivationWatchdogTimer;	// IMP=0x0001f410
- (void)_startLaunchWatchdogTimer;	// IMP=0x0001f118
- (void)_startResumeWatchdogTimer;	// IMP=0x0001f294
- (BOOL)activate;	// IMP=0x0002008c
- (id)arguments;	// IMP=0x0001f804
- (id)bundle;	// IMP=0x0001f7bc
- (id)bundleForLaunching;	// IMP=0x0001f7e8
- (id)bundleID;	// IMP=0x0001f7b4
- (unsigned int)dataUsage;	// IMP=0x0001f874
- (BOOL)deactivate;	// IMP=0x00020b1c
- (void)deactivated;	// IMP=0x00021200
- (void)dealloc;	// IMP=0x0001f5ec
- (id)demoRole;	// IMP=0x0001f748
- (id)description;	// IMP=0x0001f0bc
- (id)displayIdentifier;	// IMP=0x0001f990
- (id)displayName;	// IMP=0x0001fe64
- (BOOL)enabled;	// IMP=0x0001f720
- (void)exitedAbnormally;	// IMP=0x0002134c
- (void)exitedNormally;	// IMP=0x00021614
- (int)failedLaunchCount;	// IMP=0x0002175c
- (id)init;	// IMP=0x0001f078
- (BOOL)isDefaultRole;	// IMP=0x0001f710
- (BOOL)isRunning;	// IMP=0x00021d2c
- (BOOL)isWidget;	// IMP=0x0001f880
- (BOOL)kill;	// IMP=0x00021254
- (void)launchFailed;	// IMP=0x00021828
- (void)launchSucceeded;	// IMP=0x00021880
- (id)launchURLArgument;	// IMP=0x0001ff60
- (int)memoryWarningCount;	// IMP=0x00021a28
- (void)noteAddedStatusBarItem:(id)fp8;	// IMP=0x00021a80
- (void)noteRemovedStatusBarItem:(id)fp8;	// IMP=0x00021ae4
- (id)path;	// IMP=0x0001f7ac
- (id)pathForDefaultImage:(char *)fp8;	// IMP=0x0001fc40
- (id)pathForIcon;	// IMP=0x0001fa3c
- (unsigned int)priority;	// IMP=0x00021708
- (BOOL)relaunchesAfterAbnormalExit;	// IMP=0x00021a70
- (id)remoteApplication;	// IMP=0x00021b04
- (void)removeAppPrefs;	// IMP=0x00021764
- (void)removeStatusBarItems;	// IMP=0x000212ac
- (void)resetLaunchAlertForType:(int)fp8;	// IMP=0x00021ca0
- (id)roleID;	// IMP=0x0001f6f0
- (void)setDemoRole:(id)fp8;	// IMP=0x0001f75c
- (void)setDisplayName:(id)fp8;	// IMP=0x0001ff18
- (void)setEnabled:(BOOL)fp8;	// IMP=0x0001f740
- (void)setIsDefaultRole:(BOOL)fp8;	// IMP=0x0001f6f8
- (void)setMemoryWarningCount:(id)fp8;	// IMP=0x00021a30
- (void)setPID:(int)fp8;	// IMP=0x000219f8
- (void)setRelaunchesAfterAbnormalExit:(BOOL)fp8;	// IMP=0x00021a58
- (void)setRoleID:(id)fp8;	// IMP=0x0001f6a8
- (void)setTags:(id)fp8;	// IMP=0x0001f824
- (void)setUseDemoRole:(BOOL)fp8;	// IMP=0x0001f7a4
- (BOOL)shouldLaunchPNGless;	// IMP=0x0001fbc8
- (BOOL)showLaunchAlertForType:(int)fp8;	// IMP=0x00021b74
- (id)tags;	// IMP=0x0001f86c
- (void)watchdogForDeactivate;	// IMP=0x000210d4
- (void)watchdogForLaunch;	// IMP=0x0002119c
- (void)watchdogForResume;	// IMP=0x00021138

@end
