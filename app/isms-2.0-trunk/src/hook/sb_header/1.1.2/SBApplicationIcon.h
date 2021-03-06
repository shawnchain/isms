/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIControl.h"

@class SBApplication, SBApplicationIconBadge, SBApplicationIconLabel, UIImage, UIImageView;

@interface SBApplicationIcon : UIControl
{
    UIImage *_icon;	// 52 = 0x34
    SBApplication *_app;	// 56 = 0x38
    UIImageView *_image;	// 60 = 0x3c
    UIImageView *_reflection;	// 64 = 0x40
    SBApplicationIconBadge *_badge;	// 68 = 0x44
    SBApplicationIconLabel *_label;	// 72 = 0x48
    BOOL _drawsLabel;	// 76 = 0x4c
    BOOL _isHidden;	// 77 = 0x4d
    BOOL _isRevealable;	// 78 = 0x4e
    BOOL _inDock;	// 79 = 0x4f
}

+ (struct CGSize)defaultIconSize;	// IMP=0x0001114c
- (id)_automationID;	// IMP=0x000108b8
- (id)application;	// IMP=0x00010078
- (void)dealloc;	// IMP=0x00010024
- (id)displayName;	// IMP=0x00010898
- (id)hilightedIcon;	// IMP=0x00010660
- (id)icon;	// IMP=0x00010560
- (BOOL)ignoresMouseEvents;	// IMP=0x00010080
- (id)initWithApplication:(id)fp8;	// IMP=0x0000ff84
- (BOOL)isHidden;	// IMP=0x000103a4
- (BOOL)isRevealable;	// IMP=0x000103b4
- (void)layout;	// IMP=0x00010854
- (BOOL)pointMostlyInside:(struct CGPoint)fp8 forEvent:(struct __GSEvent *)fp16;	// IMP=0x0001093c
- (id)reflectedIcon:(BOOL)fp8;	// IMP=0x000114bc
- (void)setBadge:(id)fp8;	// IMP=0x000112a8
- (void)setDisplayedIcon:(id)fp8;	// IMP=0x00010414
- (void)setDrawsLabel:(BOOL)fp8;	// IMP=0x00011164
- (void)setHighlighted:(BOOL)fp8;	// IMP=0x000109bc
- (void)setInDock:(BOOL)fp8;	// IMP=0x00010b3c
- (void)setIsHidden:(BOOL)fp8 animate:(BOOL)fp12;	// IMP=0x0001014c
- (void)setIsRevealable:(BOOL)fp8;	// IMP=0x000103ac
- (void)setOrigin:(struct CGPoint)fp8;	// IMP=0x00010d6c
- (BOOL)shouldTrack;	// IMP=0x000108f8
- (void)showIconAnimationDidStop:(id)fp8 didFinish:(id)fp12 icon:(id)fp16;	// IMP=0x00010088
- (id)subviews;	// IMP=0x000103bc
- (void)updateLabelOrigin;	// IMP=0x000113e8

@end

