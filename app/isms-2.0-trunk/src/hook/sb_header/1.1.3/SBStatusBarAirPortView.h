/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBStatusBarContentView.h"

@interface SBStatusBarAirPortView : SBStatusBarContentView
{
    int _signalStrength;	// 36 = 0x24
    unsigned int _showsAirPort:1;	// 40 = 0x28
    unsigned int _isPolling:1;	// 40 = 0x28
}

- (void)dataConnectionTypeChanged;	// IMP=0x0005b524
- (void)dealloc;	// IMP=0x0005b370
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x0005b64c
- (id)init;	// IMP=0x0005b300
- (void)mouseUp:(struct __GSEvent *)fp8;	// IMP=0x0005b5b0
- (void)setAirPortStrength:(int)fp8;	// IMP=0x0005b4b4
- (void)setShowsAirPort:(BOOL)fp8;	// IMP=0x0005b4e0
- (void)start;	// IMP=0x0005b3c0
- (void)stop;	// IMP=0x0005b458

@end
