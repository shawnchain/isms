/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@interface SBSyncController : NSObject
{
    int _syncState;	// 4 = 0x4
    int _restoreState;	// 8 = 0x8
    int _resetState;	// 12 = 0xc
    int _sofwareUpdateState;	// 16 = 0x10
    struct __CFMachPort *_backupAgentCFPort;	// 20 = 0x14
}

+ (id)sharedInstance;	// IMP=0x000730dc
- (void)_delayedTurnOffRadio;	// IMP=0x00073b80
- (void)_invalidateBackupAgentCFPort;	// IMP=0x00073dd4
- (void)_notifyAppsSyncWillBegin;	// IMP=0x00073588
- (void)_notifyRestoreCanProceed;	// IMP=0x00073798
- (void)_rebootNow;	// IMP=0x000739b0
- (BOOL)_setupBackupAgentPort;	// IMP=0x00073e44
- (void)beginResetting;	// IMP=0x00073bf8
- (void)beginRestoring;	// IMP=0x000737c8
- (void)beginSyncing;	// IMP=0x00073674
- (void)cancelRestoring;	// IMP=0x000739a4
- (void)cancelSyncing;	// IMP=0x00073528
- (void)dealloc;	// IMP=0x0007312c
- (void)didEndResetting;	// IMP=0x00073c8c
- (void)didEndRestoring:(int)fp8;	// IMP=0x000739e0
- (void)didEndSyncing;	// IMP=0x000733a8
- (void)didShowSyncPanel;	// IMP=0x000735b8
- (void)finishEndRestoring;	// IMP=0x000739c4
- (void)finishedTerminatingApplications;	// IMP=0x000738dc
- (void)frontLockedWhenPossible;	// IMP=0x000735d4
- (void)iTunesSyncHasCompleted:(int)fp8;	// IMP=0x00073738
- (void)iTunesSyncRequestedStart;	// IMP=0x00073714
- (BOOL)isInUse;	// IMP=0x00073f90
- (BOOL)isResetting;	// IMP=0x00073b60
- (BOOL)isRestoring;	// IMP=0x00073778
- (BOOL)isSoftwareUpdating;	// IMP=0x00073ee8
- (BOOL)isSyncing;	// IMP=0x00073374
- (int)resetState;	// IMP=0x00073b78
- (int)restoreState;	// IMP=0x00073790
- (void)resumeSyncing;	// IMP=0x00073480
- (void)setSoftwareUpdateState:(int)fp8;	// IMP=0x00073ee0
- (void)showPreSoftwareUpdateScreen;	// IMP=0x00074018
- (void)startObserving;	// IMP=0x0007317c
- (void)stopObserving;	// IMP=0x000732a4
- (void)suspendSyncing;	// IMP=0x0007342c
- (int)syncState;	// IMP=0x000733a0

@end

