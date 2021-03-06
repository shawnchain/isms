/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class SBStatusBarContentsView;

@interface SBStatusBarContentView : UIView
{
    SBStatusBarContentsView *_contentsView;	// 28 = 0x1c
    int _mode;	// 32 = 0x20
}

- (void)drawText:(id)fp8 atPoint:(struct CGPoint)fp12 forWidth:(float)fp20 ellipsis:(int)fp24;	// IMP=0x0003a3e0
- (int)effectiveModeForImages;	// IMP=0x0003a37c
- (void)enableShadow;	// IMP=0x0003a48c
- (id)initWithContentsView:(id)fp8;	// IMP=0x0003a2d0
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0003a2f0
- (void)setMode:(int)fp8;	// IMP=0x0003a374
- (void)start;	// IMP=0x0003a39c
- (void)stop;	// IMP=0x0003a3a0
- (struct __GSFont *)textFont;	// IMP=0x0003a3a4

@end

