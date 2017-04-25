/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIView.h"

@class UIImage, UIImageView;

@interface SBBatteryChargingView : UIView
{
    int _type;	// 28 = 0x1c
    UIImageView *_topBatteryView;	// 32 = 0x20
    UIImageView *_bottomBatteryView;	// 36 = 0x24
    UIImageView *_reflectionView;	// 40 = 0x28
    UIImage *_lastBatteryImage;	// 44 = 0x2c
    int _lastBatteryIndex;	// 48 = 0x30
    unsigned int _showReflection:1;	// 52 = 0x34
}

+ (float)batteryHeightForType:(int)fp8;	// IMP=0x0004d494
+ (struct CGSize)defaultSizeForType:(int)fp8;	// IMP=0x0004dd74
+ (int)redChargeIndexForType:(int)fp8;	// IMP=0x0004d4c4
- (void)_batteryStatusChanged:(id)fp8;	// IMP=0x0004d89c
- (int)_currentBatteryIndex;	// IMP=0x0004d6e4
- (id)_imageFormatString;	// IMP=0x0004d874
- (void)dealloc;	// IMP=0x0004d62c
- (id)initWithFrame:(struct CGRect)fp8 type:(int)fp24;	// IMP=0x0004d4d4
- (void)setShowsReflection:(BOOL)fp8;	// IMP=0x0004d6b0

@end
