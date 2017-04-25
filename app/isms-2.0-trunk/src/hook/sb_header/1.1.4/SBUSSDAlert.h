/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlert.h"

@class NSTimer;

@interface SBUSSDAlert : SBAlert
{
    unsigned int _receivedString:1;	// 48 = 0x30
    unsigned int _dismissOnActivate:1;	// 48 = 0x30
    NSTimer *_delayedDismissTimer;	// 52 = 0x34
}

+ (void)_daemonRestart:(id)fp8;	// IMP=0x0005d148
+ (void)_newSIM:(id)fp8;	// IMP=0x0005d210
+ (id)errorStringForCode:(unsigned int)fp8;	// IMP=0x0005d0bc
+ (void)registerForAlerts;	// IMP=0x0005ce98
+ (void)registerForSettingsAlerts;	// IMP=0x0005cde4
+ (void)test;	// IMP=0x0005d02c
- (void)USSDStringAvailable:(id)fp8 allowsResponse:(BOOL)fp12;	// IMP=0x0005d278
- (void)_delayedDismiss;	// IMP=0x0005d3a4
- (BOOL)activate;	// IMP=0x0005d408
- (id)alertDisplayViewWithSize:(struct CGSize)fp8;	// IMP=0x0005d220
- (BOOL)allowsResponse;	// IMP=0x0005d348
- (BOOL)deactivate;	// IMP=0x0005d528
- (void)dealloc;	// IMP=0x0005cd60
- (BOOL)receivedString;	// IMP=0x0005d380
- (void)setDismissOnActivate:(BOOL)fp8;	// IMP=0x0005d38c

@end
