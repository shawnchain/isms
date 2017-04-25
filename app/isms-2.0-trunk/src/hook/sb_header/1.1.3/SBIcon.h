/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIControl.h"

@class NSTimer, SBIconBadge, SBIconLabel, UIImage, UIImageView, UIPushButton;

@interface SBIcon : UIControl
{
    UIImage *_icon;	// 52 = 0x34
    UIImage *_topRimmedIcon;	// 56 = 0x38
    UIImageView *_image;	// 60 = 0x3c
    UIImageView *_reflection;	// 64 = 0x40
    SBIconBadge *_badge;	// 68 = 0x44
    SBIconLabel *_label;	// 72 = 0x48
    UIPushButton *_closeBox;	// 76 = 0x4c
    unsigned int _drawsLabel:1;	// 80 = 0x50
    unsigned int _isHidden:1;	// 80 = 0x50
    unsigned int _isRevealable:1;	// 80 = 0x50
    unsigned int _inDock:1;	// 80 = 0x50
    unsigned int _isGrabbed:1;	// 80 = 0x50
    unsigned int _isGrabbing:1;	// 80 = 0x50
    unsigned int _isJittering:1;	// 80 = 0x50
    unsigned int _allowJitter:1;	// 80 = 0x50
    int _keyFrameIndex;	// 84 = 0x54
    struct CGPoint _unjitterPoint;	// 88 = 0x58
    struct CGPoint _grabPoint;	// 96 = 0x60
    NSTimer *_grabTimer;	// 104 = 0x68
}

+ (id)_jitterPositionAnimation;	// IMP=0x0008bb60
+ (id)_jitterTransformAnimation;	// IMP=0x0008be64
+ (struct CGSize)defaultIconSize;	// IMP=0x0008d8ac
+ (void)resetJitterPoints;	// IMP=0x0008ba08
- (id)_automationID;	// IMP=0x0008b454
- (BOOL)allowJitter;	// IMP=0x0008c254
- (BOOL)allowsCloseBox;	// IMP=0x0008cb34
- (void)cancelGrabTimer;	// IMP=0x0008c4ec
- (BOOL)cancelMouseTracking;	// IMP=0x0008c5b0
- (void)closeBoxClicked:(id)fp8;	// IMP=0x0008cb84
- (void)completeUninstall;	// IMP=0x0008cc0c
- (void)dealloc;	// IMP=0x0008a94c
- (id)description;	// IMP=0x0008cc10
- (id)dictionaryRepresentation;	// IMP=0x0008c9f8
- (id)displayIdentifier;	// IMP=0x0008adf8
- (id)displayName;	// IMP=0x0008adf0
- (float)grabDuration;	// IMP=0x0008c2d8
- (void)grabbedIcon;	// IMP=0x0008c3f8
- (void)hideCloseBoxAnimationDidStop:(id)fp8 didFinish:(id)fp12 closeBox:(id)fp16;	// IMP=0x0008cb3c
- (id)hilightedIcon;	// IMP=0x0008db04
- (id)icon;	// IMP=0x0008af7c
- (BOOL)ignoresMouseEvents;	// IMP=0x0008aa0c
- (id)initWithDefaultSize;	// IMP=0x0008a828
- (BOOL)isHidden;	// IMP=0x0008ad44
- (BOOL)isRevealable;	// IMP=0x0008ad6c
- (BOOL)isShowingCloseBox;	// IMP=0x0008cb74
- (void)jitter;	// IMP=0x0008d208
- (void)launch;	// IMP=0x0008ca84
- (BOOL)launchEnabled;	// IMP=0x0008ae28
- (void)layout;	// IMP=0x0008b1cc
- (void)mouseCancelInIcon:(id)fp8;	// IMP=0x0008c52c
- (void)mouseDown:(struct __GSEvent *)fp8;	// IMP=0x0008c604
- (void)mouseDragged:(struct __GSEvent *)fp8;	// IMP=0x0008c760
- (void)mouseUp:(struct __GSEvent *)fp8;	// IMP=0x0008c8f4
- (BOOL)pointInside:(struct CGPoint)fp8 forEvent:(struct __GSEvent *)fp16;	// IMP=0x0008ca88
- (BOOL)pointMostlyInside:(struct CGPoint)fp8 forEvent:(struct __GSEvent *)fp16;	// IMP=0x0008b4d4
- (id)reflectedIcon:(BOOL)fp8;	// IMP=0x0008d8c4
- (void)resetIconImage;	// IMP=0x0008a9d0
- (void)setAllowJitter:(BOOL)fp8;	// IMP=0x0008c21c
- (void)setBadge:(id)fp8;	// IMP=0x0008d384
- (void)setDisplayedIcon:(id)fp8;	// IMP=0x0008ae30
- (void)setDrawsLabel:(BOOL)fp8;	// IMP=0x0008b210
- (void)setHighlighted:(BOOL)fp8;	// IMP=0x0008b554
- (void)setIconPosition:(struct CGPoint)fp8;	// IMP=0x0008c294
- (void)setInDock:(BOOL)fp8;	// IMP=0x0008b664
- (void)setIsGrabbed:(BOOL)fp8;	// IMP=0x0008c2fc
- (void)setIsHidden:(BOOL)fp8 animate:(BOOL)fp12;	// IMP=0x0008aad8
- (void)setIsRevealable:(BOOL)fp8;	// IMP=0x0008ad54
- (void)setIsShowingCloseBox:(BOOL)fp8;	// IMP=0x0008cf60
- (void)setOrigin:(struct CGPoint)fp8;	// IMP=0x0008b8e8
- (BOOL)shouldListInCapabilities;	// IMP=0x0008a9c8
- (BOOL)shouldTrack;	// IMP=0x0008b490
- (void)showIconAnimationDidStop:(id)fp8 didFinish:(id)fp12 icon:(id)fp16;	// IMP=0x0008aa14
- (void)startJitteringAnimation;	// IMP=0x0008c0e0
- (void)stopJitteringAnimation;	// IMP=0x0008c1e4
- (id)subviews;	// IMP=0x0008ad7c
- (id)tags;	// IMP=0x0008ae00
- (id)topRimmedIcon;	// IMP=0x0008b000
- (void)unjitter;	// IMP=0x0008c260
- (void)updateLabelKerning;	// IMP=0x0008b3f4
- (void)updateLabelOrigin;	// IMP=0x0008d4d8

@end
