/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBStatusBarContentView.h"

@class UIImage, UIImageView;

@interface SBStatusBarBluetoothView : SBStatusBarContentView
{
    UIImage *_icon;	// 36 = 0x24
    BOOL _animating;	// 40 = 0x28
    UIImageView *_activeView;	// 44 = 0x2c
    UIImageView *_baseLayer;	// 48 = 0x30
    BOOL _isStarted;	// 52 = 0x34
}

+ (void)initialize;	// IMP=0x00065f90
- (void)_btConnectionStatusChanged:(id)fp8;	// IMP=0x00065e94
- (void)_btDeviceConnected;	// IMP=0x00065d74
- (void)_btDeviceDisconnected:(id)fp8;	// IMP=0x00065f08
- (void)_btPowerPrefChanged:(id)fp8;	// IMP=0x000660f8
- (void)_btStatusChanged:(id)fp8;	// IMP=0x00065b40
- (int)_effectiveMode;	// IMP=0x000659c8
- (void)_setupActiveView;	// IMP=0x000659e8
- (void)_start;	// IMP=0x00065ffc
- (void)animationDidStop:(id)fp8;	// IMP=0x00065f28
- (int)btStatus;	// IMP=0x00065ac8
- (void)dealloc;	// IMP=0x000661d8
- (id)icon;	// IMP=0x00065964
- (id)init;	// IMP=0x0006596c
- (void)start;	// IMP=0x00066114
- (void)stop;	// IMP=0x00066190

@end

