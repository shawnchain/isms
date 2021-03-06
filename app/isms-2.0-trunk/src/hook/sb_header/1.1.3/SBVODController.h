/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray, NSMutableSet, NSTimer;

@interface SBVODController : NSObject
{
    NSMutableArray *_alarms;	// 4 = 0x4
    NSMutableSet *_alarmsToFire;	// 8 = 0x8
    NSMutableSet *_alarmsToFireWhenMovieEnds;	// 12 = 0xc
    NSTimer *_timer;	// 16 = 0x10
    NSTimer *_movieTimeoutTimer;	// 20 = 0x14
    unsigned int _reloadingForBoot:1;	// 24 = 0x18
}

+ (id)sharedInstance;	// IMP=0x000887b0
- (void)_alarmFired:(id)fp8;	// IMP=0x00088ce8
- (BOOL)_alarmIsExpired:(id)fp8 hints:(id)fp12;	// IMP=0x0008953c
- (id)_expiredAlarmsPath;	// IMP=0x00089608
- (void)_movieEndTimeout:(id)fp8;	// IMP=0x000898dc
- (void)_noteExpiredAlarms:(id)fp8;	// IMP=0x00089640
- (void)_nowPlayingInfoChanged;	// IMP=0x00089944
- (void)_presentAlarmAlerts:(id)fp8;	// IMP=0x00088eb8
- (void)_presentAlarmsExpiringWithinTimeInterval:(double)fp8;	// IMP=0x00089094
- (void)_scheduleTimer;	// IMP=0x000891cc
- (void)dealloc;	// IMP=0x00088674
- (void)didWakeFromSleep;	// IMP=0x00088800
- (void)iTunesSyncHasCompleted:(int)fp8;	// IMP=0x00088c5c
- (void)iTunesSyncRequestedStart;	// IMP=0x00088bd8
- (id)init;	// IMP=0x00088518
- (void)reloadAlarms:(BOOL)fp8;	// IMP=0x00088940

@end

