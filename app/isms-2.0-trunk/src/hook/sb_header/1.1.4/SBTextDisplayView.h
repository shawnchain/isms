/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class NSString;

@interface SBTextDisplayView : UIView
{
    NSString *_text;	// 28 = 0x1c
    NSString *_style;	// 32 = 0x20
}

- (void)_updateText;	// IMP=0x00058da0
- (void)dealloc;	// IMP=0x00058d40
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x00058f0c
- (id)initWithWidth:(float)fp8 text:(id)fp12 style:(id)fp16;	// IMP=0x00058c7c
- (void)setStyle:(id)fp8;	// IMP=0x00058e50
- (void)setText:(id)fp8;	// IMP=0x00058eac

@end
