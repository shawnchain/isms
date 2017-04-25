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

- (void)drawText:(id)fp8 atPoint:(struct CGPoint)fp12 forWidth:(float)fp20 ellipsis:(int)fp24;	// IMP=0x00040468
- (int)effectiveModeForImages;	// IMP=0x00040404
- (void)enableShadow;	// IMP=0x00040514
- (id)initWithContentsView:(id)fp8;	// IMP=0x00040358
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00040378
- (void)setMode:(int)fp8;	// IMP=0x000403fc
- (void)start;	// IMP=0x00040424
- (void)stop;	// IMP=0x00040428
- (struct __GSFont *)textFont;	// IMP=0x0004042c

@end
