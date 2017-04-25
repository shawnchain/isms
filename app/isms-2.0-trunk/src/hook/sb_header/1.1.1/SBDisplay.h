/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */
#ifndef SBDISPLAY_H_
#define SBDISPLAY_H_

#import "NSObject.h"

@class NSMutableDictionary, NSMutableSet;

@interface SBDisplay : NSObject
{
    NSMutableDictionary *_activationValues;	// 4 = 0x4
    NSMutableDictionary *_deactivationValues;	// 8 = 0x8
    int _activationSettings;	// 12 = 0xc
    int _deactivationSettings;	// 16 = 0x10
    NSMutableSet *_suppressVolumeHudCategories;	// 20 = 0x14
    float _autoDimOverride;	// 24 = 0x18
    float _autoLockOverride;	// 28 = 0x1c
    unsigned int _expectsFaceContact:1;	// 32 = 0x20
    unsigned int _disallowTouchPoints:1;	// 32 = 0x20
    unsigned int _accelerometerDeviceOrientationChangedEventsEnabled:1;	// 32 = 0x20
    unsigned int _accelerometerRawEventsEnabled:1;	// 32 = 0x20
    unsigned int _proximityEventsEnabled:1;	// 32 = 0x20
    unsigned int _showsProgress:1;	// 32 = 0x20
}

+ (id)defaultValueForKey:(const id)fp8 displayIdentifier:(id)fp12;	// IMP=0x0003c6ac
+ (void)loadDisplayStates;	// IMP=0x0003c340
+ (void)resetDefaultValuesForDisplayIdentifier:(id)fp8;	// IMP=0x0003c714
+ (void)saveDisplayStates;	// IMP=0x0003c4ec
+ (void)setDefaultValue:(id)fp8 forKey:(const id)fp12 displayIdentifier:(id)fp16;	// IMP=0x0003c578
- (BOOL)accelerometerDeviceOrientationChangedEventsEnabled;	// IMP=0x0003bddc
- (BOOL)accelerometerRawEventsEnabled;	// IMP=0x0003be44
- (BOOL)activate;	// IMP=0x0003b6a4
- (BOOL)activationSetting:(int)fp8;	// IMP=0x0003b4cc
- (id)activationSettingsDescription;	// IMP=0x0003c7b0
- (id)activationValue:(int)fp8;	// IMP=0x0003b450
- (BOOL)allowsInCallStatusBar;	// IMP=0x0003b880
- (float)autoDimTime;	// IMP=0x0003bb84
- (float)autoLockTime;	// IMP=0x0003bc48
- (void)clearActivationSettings;	// IMP=0x0003b314
- (void)clearDeactivationSettings;	// IMP=0x0003b4dc
- (id)copyWithZone:(struct _NSZone *)fp8;	// IMP=0x0003b2ec
- (BOOL)deactivate;	// IMP=0x0003b6b8
- (void)deactivated;	// IMP=0x0003b6c0
- (BOOL)deactivationSetting:(int)fp8;	// IMP=0x0003b538
- (id)deactivationSettingsDescription;	// IMP=0x0003cbd4
- (id)deactivationValue:(int)fp8;	// IMP=0x0003b628
- (void)dealloc;	// IMP=0x0003b280
- (id)description;	// IMP=0x0003c0c8
- (id)displayIdentifier;	// IMP=0x0003b308
- (void)exitedAbnormally;	// IMP=0x0003b774
- (void)exitedNormally;	// IMP=0x0003b87c
- (BOOL)expectsFaceContact;	// IMP=0x0003bd78
- (BOOL)kill;	// IMP=0x0003b76c
- (BOOL)proximityEventsEnabled;	// IMP=0x0003beac
- (void)setAccelerometerDeviceOrientationChangedEventsEnabled:(BOOL)fp8;	// IMP=0x0003bd84
- (void)setAccelerometerRawEventsEnabled:(BOOL)fp8;	// IMP=0x0003bdec
- (void)setActivationSetting:(int)fp8 flag:(BOOL)fp12;	// IMP=0x0003b344
- (void)setActivationSetting:(int)fp8 value:(id)fp12;	// IMP=0x0003b370
- (void)setAutoDimTime:(float)fp8;	// IMP=0x0003bc40
- (void)setAutoLockTime:(float)fp8;	// IMP=0x0003bd04
- (void)setDeactivationSetting:(int)fp8 flag:(BOOL)fp12;	// IMP=0x0003b50c
- (void)setDeactivationSetting:(int)fp8 value:(id)fp12;	// IMP=0x0003b548
- (void)setExpectsFaceContact:(BOOL)fp8;	// IMP=0x0003bd0c
- (void)setProximityEventsEnabled:(BOOL)fp8;	// IMP=0x0003be54
- (void)setShowsProgress:(BOOL)fp8;	// IMP=0x0003bebc
- (void)setSystemVolumeHUDEnabled:(BOOL)fp8 forCategory:(id)fp12;	// IMP=0x0003bee4
- (void)setTouchPointsAllowed:(BOOL)fp8;	// IMP=0x0003c06c
- (BOOL)showSystemVolumeHUDForCategory:(id)fp8;	// IMP=0x0003c008
- (BOOL)showsProgress;	// IMP=0x0003bed4
- (int)statusBarMode;	// IMP=0x0003bab8
- (int)statusBarOrientation;	// IMP=0x0003bb48
- (BOOL)touchPointsAllowed;	// IMP=0x0003c0b4
- (void)updateStatusBar:(float)fp8;	// IMP=0x0003ba8c
- (void)updateStatusBar:(float)fp8 fence:(int)fp12 animation:(int)fp16;	// IMP=0x0003b95c

@end

#endif /*SBDISPLAY_H_*/