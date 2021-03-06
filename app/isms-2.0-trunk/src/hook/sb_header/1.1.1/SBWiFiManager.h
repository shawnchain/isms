/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSLock;

@interface SBWiFiManager : NSObject
{
    struct _Apple80211 *_wireless;	// 4 = 0x4
    BOOL _busy;	// 8 = 0x8
    BOOL _joining;	// 9 = 0x9
    BOOL _cancel;	// 10 = 0xa
    NSLock *_lock;	// 12 = 0xc
    id _delegate;	// 16 = 0x10
}

+ (id)sharedInstance;	// IMP=0x0006e454
- (void)_SBAirPortConfigurationChanged;	// IMP=0x0006ee04
- (void)_SBAirPortPowerChanged;	// IMP=0x0006edb0
- (void)_SBAirPortUpdateTimer;	// IMP=0x0006eda0
- (void)_joinComplete:(id)fp8;	// IMP=0x0006ed00
- (void)_joinNetwork:(id)fp8;	// IMP=0x0006ec4c
- (void)_joinNetworkThread:(id)fp8;	// IMP=0x0006eb18
- (void)_scanComplete:(id)fp8;	// IMP=0x0006e9b0
- (void)_scanThread;	// IMP=0x0006e76c
- (BOOL)busy;	// IMP=0x0006e710
- (void)dealloc;	// IMP=0x0006e4a4
- (void)dismissAlerts;	// IMP=0x0006e720
- (id)init;	// IMP=0x0006e548
- (void)joinNetwork:(id)fp8;	// IMP=0x0006eeb0
- (void)joinSecureNetwork:(id)fp8 password:(id)fp12;	// IMP=0x0006ee58
- (BOOL)joining;	// IMP=0x0006e718
- (void)scan;	// IMP=0x0006e69c
- (void)setDelegate:(id)fp8;	// IMP=0x0006e694

@end

