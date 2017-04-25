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

- (struct CGRect)_progressRect;	// IMP=0x0004113c
- (void)backspace:(id)fp8;	// IMP=0x00040880
- (void)dealloc;	// IMP=0x00040670
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x00040d10
- (void)highlight:(id)fp8;	// IMP=0x000407e0
- (id)initWithTitle:(id)fp8 string:(id)fp12;	// IMP=0x0004058c
- (void)resize;	// IMP=0x00040908
- (void)setTitle:(id)fp8;	// IMP=0x00040ca0
- (void)setTitle:(id)fp8 string:(id)fp12;	// IMP=0x00040bd4
- (void)showBackspace:(BOOL)fp8;	// IMP=0x00040ec0
- (void)showProgressIndicator:(BOOL)fp8;	// IMP=0x000406e8
- (id)title;	// IMP=0x00040c88
- (void)unhighlight:(id)fp8;	// IMP=0x00040830

@end
