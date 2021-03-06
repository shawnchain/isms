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

- (void)dataConnectionTypeChanged;	// IMP=0x000591ac
- (void)dealloc;	// IMP=0x00058ff8
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x000592d4
- (id)init;	// IMP=0x00058f88
- (void)mouseUp:(struct __GSEvent *)fp8;	// IMP=0x00059238
- (void)setAirPortStrength:(int)fp8;	// IMP=0x0005913c
- (void)setShowsAirPort:(BOOL)fp8;	// IMP=0x00059168
- (void)start;	// IMP=0x00059048
- (void)stop;	// IMP=0x000590e0

@end

