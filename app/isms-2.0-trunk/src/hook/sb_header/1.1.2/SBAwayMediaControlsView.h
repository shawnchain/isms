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

- (void)_clearSeekedFlag:(id)fp8;	// IMP=0x0007bec0
- (void)_controlButtonAction:(id)fp8;	// IMP=0x0007bed0
- (id)_createButtonWithImage:(id)fp8 action:(SEL)fp12 tag:(int)fp16;	// IMP=0x0007bbb8
- (void)_nowPlayingChanged:(id)fp8;	// IMP=0x0007c380
- (void)_registerForNowPlayingNotifications;	// IMP=0x0007c1c0
- (void)_registerForVolumeNotifications;	// IMP=0x0007c2a0
- (void)_systemVolumeChanged:(id)fp8;	// IMP=0x0007c39c
- (void)_unregisterForNowPlayingNotifications;	// IMP=0x0007c240
- (void)_unregisterForVolumeNotifications;	// IMP=0x0007c320
- (void)_updateInformation;	// IMP=0x0007bcb0
- (void)_volumeChange:(id)fp8;	// IMP=0x0007bfc0
- (void)dealloc;	// IMP=0x0007bac0
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0007b76c
- (void)layoutSubviews;	// IMP=0x0007c418
- (void)setAlpha:(float)fp8;	// IMP=0x0007be48
- (void)viewHandleTouchPause:(id)fp8 isDown:(BOOL)fp12;	// IMP=0x0007c054
- (double)viewTouchPauseThreshold:(id)fp8;	// IMP=0x0007c1b0

@end
