/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBStatusBarContentView.h"

@class NSString, NSTimer;

@interface SBStatusBarTimeView : SBStatusBarContentView
{
    NSTimer *_dateTimer;	// 36 = 0x24
    NSString *_time;	// 40 = 0x28
    struct CGRect _textRect;	// 44 = 0x2c
}

- (void)dealloc;	// IMP=0x0003ee58
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x0003f008
- (id)init;	// IMP=0x0003ed6c
- (void)start;	// IMP=0x0003eebc
- (void)stop;	// IMP=0x0003efc8
- (void)tile;	// IMP=0x0003f06c
- (void)updateClockFormat;	// IMP=0x0003edfc

@end
