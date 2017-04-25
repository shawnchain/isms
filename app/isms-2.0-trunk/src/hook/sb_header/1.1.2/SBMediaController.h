/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSDictionary;

@interface SBMediaController : NSObject
{
    int _manualVolumeChangeCount;	// 4 = 0x4
    NSDictionary *_nowPlayingInfo;	// 8 = 0x8
}

+ (id)sharedInstance;	// IMP=0x00081468
- (BOOL)_performIAPCommand:(int)fp8 status:(int)fp12;	// IMP=0x00081cd0
- (void)_registerForAVSystemControllerNotifications;	// IMP=0x000818e4
- (void)_serverConnectionDied:(id)fp8;	// IMP=0x00081b1c
- (void)_systemVolumeChanged:(id)fp8;	// IMP=0x00081b58
- (void)_unregisterForAVSystemControllerNotifications;	// IMP=0x00081a5c
- (BOOL)beginSeek:(int)fp8;	// IMP=0x00081730
- (BOOL)changeTrack:(int)fp8;	// IMP=0x00081700
- (void)dealloc;	// IMP=0x000813fc
- (BOOL)endSeek:(int)fp8;	// IMP=0x00081760
- (void)handleVolumeEvent:(struct __GSEvent *)fp8;	// IMP=0x0008186c
- (BOOL)hasTrack;	// IMP=0x00081538
- (id)init;	// IMP=0x000813a4
- (BOOL)isFirstTrack;	// IMP=0x00081568
- (BOOL)isLastTrack;	// IMP=0x000815d0
- (BOOL)isPlaying;	// IMP=0x00081638
- (void)musicPlayerDied:(id)fp8;	// IMP=0x00081b38
- (id)nowPlayingAlbum;	// IMP=0x000816d8
- (id)nowPlayingArtist;	// IMP=0x00081688
- (id)nowPlayingTitle;	// IMP=0x000816b0
- (void)setNowPlayingInfo:(id)fp8;	// IMP=0x000814b8
- (void)setVolume:(float)fp8;	// IMP=0x00081810
- (BOOL)togglePlayPause;	// IMP=0x00081790
- (float)volume;	// IMP=0x000817b8

@end
