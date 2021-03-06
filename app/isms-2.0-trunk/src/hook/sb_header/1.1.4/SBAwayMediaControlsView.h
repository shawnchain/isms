/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class UIPushButton, UIScrubberControl;

@interface SBAwayMediaControlsView : UIView
{
    unsigned int _seeked:1;	// 28 = 0x1c
    UIPushButton *_prevButton;	// 32 = 0x20
    UIPushButton *_nextButton;	// 36 = 0x24
    UIPushButton *_playPauseButton;	// 40 = 0x28
    UIScrubberControl *_slider;	// 44 = 0x2c
}

- (void)_clearSeekedFlag:(id)fp8;	// IMP=0x0007e504
- (void)_controlButtonAction:(id)fp8;	// IMP=0x0007e514
- (id)_createButtonWithImage:(id)fp8 action:(SEL)fp12 tag:(int)fp16;	// IMP=0x0007e1fc
- (void)_nowPlayingChanged:(id)fp8;	// IMP=0x0007e9c4
- (void)_registerForNowPlayingNotifications;	// IMP=0x0007e804
- (void)_registerForVolumeNotifications;	// IMP=0x0007e8e4
- (void)_systemVolumeChanged:(id)fp8;	// IMP=0x0007e9e0
- (void)_unregisterForNowPlayingNotifications;	// IMP=0x0007e884
- (void)_unregisterForVolumeNotifications;	// IMP=0x0007e964
- (void)_updateInformation;	// IMP=0x0007e2f4
- (void)_volumeChange:(id)fp8;	// IMP=0x0007e604
- (void)dealloc;	// IMP=0x0007e104
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0007ddb0
- (void)layoutSubviews;	// IMP=0x0007ea5c
- (void)setAlpha:(float)fp8;	// IMP=0x0007e48c
- (void)viewHandleTouchPause:(id)fp8 isDown:(BOOL)fp12;	// IMP=0x0007e698
- (double)viewTouchPauseThreshold:(id)fp8;	// IMP=0x0007e7f4

@end

