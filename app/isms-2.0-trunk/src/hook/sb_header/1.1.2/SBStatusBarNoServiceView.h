/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBStatusBarContentView.h"

@class NSString;

@interface SBStatusBarNoServiceView : SBStatusBarContentView
{
    NSString *_errorString;	// 36 = 0x24
}

+ (id)displayStringForRegistrationStatus:(int)fp8;	// IMP=0x0005d418
+ (id)displayStringForSIMStatus:(id)fp8;	// IMP=0x0005d2b4
- (void)dealloc;	// IMP=0x0005d590
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x0005d5e4
- (id)initWithErrorString:(id)fp8;	// IMP=0x0005d4b8
- (struct __GSFont *)textFont;	// IMP=0x0005d684

@end
