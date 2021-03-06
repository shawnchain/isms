/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class NSString, UIProgressIndicator, UIPushButton;

@interface SBInfoBubble : UIView
{
    NSString *_title;	// 28 = 0x1c
    NSString *_string;	// 32 = 0x20
    struct CGRect _titleRect;	// 36 = 0x24
    struct CGRect _stringRect;	// 52 = 0x34
    UIPushButton *_backspace;	// 68 = 0x44
    UIProgressIndicator *_progressIndicator;	// 72 = 0x48
}

- (struct CGRect)_progressRect;	// IMP=0x00047410
- (void)backspace:(id)fp8;	// IMP=0x00046b54
- (void)dealloc;	// IMP=0x00046944
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x00046fe4
- (void)highlight:(id)fp8;	// IMP=0x00046ab4
- (id)initWithTitle:(id)fp8 string:(id)fp12;	// IMP=0x00046860
- (void)resize;	// IMP=0x00046bdc
- (void)setTitle:(id)fp8;	// IMP=0x00046f74
- (void)setTitle:(id)fp8 string:(id)fp12;	// IMP=0x00046ea8
- (void)showBackspace:(BOOL)fp8;	// IMP=0x00047194
- (void)showProgressIndicator:(BOOL)fp8;	// IMP=0x000469bc
- (id)title;	// IMP=0x00046f5c
- (void)unhighlight:(id)fp8;	// IMP=0x00046b04

@end

