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

- (void)dealloc;	// IMP=0x0003e4a4
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x0003e654
- (id)init;	// IMP=0x0003e3b8
- (void)start;	// IMP=0x0003e508
- (void)stop;	// IMP=0x0003e614
- (void)tile;	// IMP=0x0003e6b8
- (void)updateClockFormat;	// IMP=0x0003e448

@end

