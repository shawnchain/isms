/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBStatusBarContentView.h"

@class NSString;

@interface SBStatusBarOperatorNameView : SBStatusBarContentView
{
    float _letterSpacing;	// 36 = 0x24
    NSString *_operatorName;	// 40 = 0x28
    BOOL _fullSize;	// 44 = 0x2c
}

- (float)calculateLetterSpacingForOperatorName:(id)fp8;	// IMP=0x00037e20
- (void)dealloc;	// IMP=0x00037b50
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x00037c7c
- (id)initWithOperatorName:(id)fp8;	// IMP=0x00037abc
- (id)operatorName;	// IMP=0x00037f0c
- (id)operatorNameStyle;	// IMP=0x00037ba4
- (void)setOperatorName:(id)fp8 fullSize:(BOOL)fp12;	// IMP=0x00038c58

@end

