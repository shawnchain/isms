/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class SBUIController, UIImageView;

@interface SBButtonBar : UIView
{
    SBUIController *_uiController;	// 28 = 0x1c
    UIImageView *_dockBGView;	// 32 = 0x20
}

+ (struct CGSize)defaultSize;	// IMP=0x000197dc
- (void)dealloc;	// IMP=0x00019780
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x00019588
- (void)reload;	// IMP=0x00019864
- (void)setUIController:(id)fp8;	// IMP=0x000197d4

@end

