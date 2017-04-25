/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class NSString, NSTimer, SBAwayMediaControlsView, TPLCDTextView;

@interface SBAwayDateView : UIView
{
    NSTimer *_dateTimer;	// 28 = 0x1c
    TPLCDTextView *_timeLabel;	// 32 = 0x20
    TPLCDTextView *_titleLabel;	// 36 = 0x24
    NSString *_title;	// 40 = 0x28
    SBAwayMediaControlsView *_controlsView;	// 44 = 0x2c
}

- (id)controlsView;	// IMP=0x000268d0
- (void)dealloc;	// IMP=0x00025f2c
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0002698c
- (BOOL)isShowingControls;	// IMP=0x00026708
- (id)labelWithFontSize:(float)fp8 origin:(struct CGPoint)fp12;	// IMP=0x0002617c
- (id)labelWithFontSize:(float)fp8 origin:(struct CGPoint)fp12 fontName:(const char *)fp20;	// IMP=0x00025fb8
- (void)movedToSuperview:(id)fp8;	// IMP=0x000266ac
- (void)removeFromSuperview;	// IMP=0x0002663c
- (void)setIsShowingControls:(BOOL)fp8;	// IMP=0x00026740
- (void)setTitle:(id)fp8;	// IMP=0x000265e0
- (void)updateClock;	// IMP=0x000264d4
- (void)updateClockFormat;	// IMP=0x00026470
- (void)updateLabels;	// IMP=0x000261c4

@end
