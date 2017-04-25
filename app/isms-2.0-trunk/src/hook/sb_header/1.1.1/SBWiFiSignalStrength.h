/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIImageView.h"

@interface SBWiFiSignalStrength : UIImageView
{
    int _bars;	// 52 = 0x34
    int _rawStrength;	// 56 = 0x38
    BOOL _hilited;	// 60 = 0x3c
    BOOL _selected;	// 61 = 0x3d
    BOOL _secure;	// 62 = 0x3e
    BOOL _joining;	// 63 = 0x3f
    UIImageView *_icon;	// 64 = 0x40
}

+ (void)hideSpinner;	// IMP=0x0006f0dc
- (void)dealloc;	// IMP=0x0006f760
- (void)hide;	// IMP=0x0006fb50
- (BOOL)hilited;	// IMP=0x0006fbb4
- (id)initWithFrame:(struct CGRect)fp8 inView:(id)fp24;	// IMP=0x0006f144
- (BOOL)joining;	// IMP=0x0006f818
- (BOOL)secure;	// IMP=0x0006fbf0
- (BOOL)selected;	// IMP=0x0006fb48
- (void)setHilited:(BOOL)fp8;	// IMP=0x0006fbbc
- (void)setJoining:(BOOL)fp8;	// IMP=0x0006f820
- (void)setSecure:(BOOL)fp8;	// IMP=0x0006fbf8
- (void)setSelected:(BOOL)fp8;	// IMP=0x0006fb80
- (void)setSpinnerHilited:(BOOL)fp8;	// IMP=0x0006f110
- (void)updateImage;	// IMP=0x0006fc2c
- (void)updateStrength:(id)fp8;	// IMP=0x0006f99c

@end
