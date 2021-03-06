/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBApplicationIcon.h"

@class UIImage, UIImageView;

@interface SBPhoneApplicationIcon : SBApplicationIcon
{
    UIImageView *_blinkIcon;	// 112 = 0x70
    UIImage *_blinkOnIcon;	// 116 = 0x74
    unsigned int _isBlinking:1;	// 120 = 0x78
}

- (void)_activeCallStateChanged:(id)fp8;	// IMP=0x00047fd8
- (void)_startTimer;	// IMP=0x00047b1c
- (void)_stopTimer;	// IMP=0x00047db0
- (void)alertWindowHidden;	// IMP=0x00047e88
- (void)dealloc;	// IMP=0x00047a50
- (id)icon;	// IMP=0x00047ac0
- (void)iconBecameVisible;	// IMP=0x00047e00
- (void)iconWillBeHidden;	// IMP=0x00047e44
- (id)initWithApplication:(id)fp8;	// IMP=0x000479dc
- (void)mouseUp:(struct __GSEvent *)fp8;	// IMP=0x00047f0c
- (void)startBlinking;	// IMP=0x00047eb8
- (void)stopBlinking;	// IMP=0x00047ebc

@end

