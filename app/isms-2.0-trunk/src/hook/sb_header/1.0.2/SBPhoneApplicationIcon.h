/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBApplicationIcon.h"

@class UIImage, UIImageView;

@interface SBPhoneApplicationIcon : SBApplicationIcon
{
    UIImageView *_blinkIcon;	// 76 = 0x4c
    UIImage *_blinkOnIcon;	// 80 = 0x50
    unsigned int _isBlinking:1;	// 84 = 0x54
}

- (void)_activeCallStateChanged:(id)fp8;	// IMP=0x00041804
- (void)_startTimer;	// IMP=0x00041350
- (void)_stopTimer;	// IMP=0x000415e4
- (void)alertWindowHidden;	// IMP=0x000416b4
- (void)dealloc;	// IMP=0x00041284
- (id)icon;	// IMP=0x000412f4
- (void)iconBecameVisible;	// IMP=0x00041634
- (void)iconWillBeHidden;	// IMP=0x00041674
- (id)initWithApplication:(id)fp8;	// IMP=0x00041210
- (void)mouseUp:(struct __GSEvent *)fp8;	// IMP=0x00041738
- (void)startBlinking;	// IMP=0x000416e4
- (void)stopBlinking;	// IMP=0x000416e8

@end

