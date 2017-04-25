/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class NSString, NSTimer, TPLCDTextView;

@interface SBAwayDateView : UIView
{
    NSTimer *_dateTimer;	// 28 = 0x1c
    TPLCDTextView *_timeLabel;	// 32 = 0x20
    TPLCDTextView *_titleLabel;	// 36 = 0x24
    NSString *_title;	// 40 = 0x28
}

- (void)dealloc;	// IMP=0x00022a94
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00023124
- (id)labelWithFontSize:(float)fp8 origin:(struct CGPoint)fp12;	// IMP=0x00022ce4
- (id)labelWithFontSize:(float)fp8 origin:(struct CGPoint)fp12 fontName:(const char *)fp20;	// IMP=0x00022b20
- (void)movedToSuperview:(id)fp8;	// IMP=0x000230c8
- (void)removeFromSuperview;	// IMP=0x00023058
- (void)setTitle:(id)fp8;	// IMP=0x00022ffc
- (void)updateClock;	// IMP=0x00022ef0
- (void)updateClockFormat;	// IMP=0x00022e8c
- (void)updateLabels;	// IMP=0x00022d2c

@end
