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

+ (struct CGSize)defaultSize;	// IMP=0x00019540
- (void)dealloc;	// IMP=0x000194e4
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x000192ec
- (void)reload;	// IMP=0x000195c8
- (void)setUIController:(id)fp8;	// IMP=0x00019538

@end
