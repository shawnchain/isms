/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class NSString, UITextLabel;

@interface VolumeControlView : UIView
{
    float _volume;	// 28 = 0x1c
    int _mode;	// 32 = 0x20
    BOOL _headphonesPresent;	// 36 = 0x24
    UITextLabel *_label1;	// 40 = 0x28
    UITextLabel *_label2;	// 44 = 0x2c
    NSString *_line1;	// 48 = 0x30
    NSString *_line2;	// 52 = 0x34
}

+ (struct CGSize)controlSize;	// IMP=0x00039e4c
+ (void)loadImages;	// IMP=0x00039b88
- (void)_checkHeadphonesPresent;	// IMP=0x00039f70
- (void)_drawLine1;	// IMP=0x0003a490
- (void)_drawLine2;	// IMP=0x0003a7dc
- (BOOL)_showLabel;	// IMP=0x0003a42c
- (void)_updateLabelStrings;	// IMP=0x0003a128
- (void)dealloc;	// IMP=0x0003a3cc
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x0003aafc
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00039eac
- (void)setMode:(int)fp8;	// IMP=0x0003a048
- (void)setVolume:(float)fp8 mode:(int)fp12;	// IMP=0x0003a098
- (float)volume;	// IMP=0x0003a120

@end
