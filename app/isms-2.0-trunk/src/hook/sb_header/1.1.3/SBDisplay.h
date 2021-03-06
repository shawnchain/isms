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

+ (id)defaultValueForKey:(const id)fp8 displayIdentifier:(id)fp12;	// IMP=0x0003cfb4
+ (void)loadDisplayStates;	// IMP=0x0003cc48
+ (void)resetDefaultValuesForDisplayIdentifier:(id)fp8;	// IMP=0x0003d01c
+ (void)saveDisplayStates;	// IMP=0x0003cdf4
+ (void)setDefaultValue:(id)fp8 forKey:(const id)fp12 displayIdentifier:(id)fp16;	// IMP=0x0003ce80
- (BOOL)accelerometerDeviceOrientationChangedEventsEnabled;	// IMP=0x0003c6e4
- (BOOL)accelerometerRawEventsEnabled;	// IMP=0x0003c74c
- (BOOL)activate;	// IMP=0x0003bfa4
- (BOOL)activationSetting:(int)fp8;	// IMP=0x0003bdcc
- (id)activationSettingsDescription;	// IMP=0x0003d0b8
- (id)activationValue:(int)fp8;	// IMP=0x0003bd50
- (BOOL)allowsEventOnlySuspension;	// IMP=0x0003c180
- (BOOL)allowsInCallStatusBar;	// IMP=0x0003c188
- (float)autoDimTime;	// IMP=0x0003c48c
- (float)autoLockTime;	// IMP=0x0003c550
- (void)clearActivationSettings;	// IMP=0x0003bc14
- (void)clearDeactivationSettings;	// IMP=0x0003bddc
- (id)copyWithZone:(struct _NSZone *)fp8;	// IMP=0x0003bbec
- (BOOL)deactivate;	// IMP=0x0003bfb8
- (void)deactivated;	// IMP=0x0003bfc0
- (BOOL)deactivationSetting:(int)fp8;	// IMP=0x0003be38
- (id)deactivationSettingsDescription;	// IMP=0x0003d4dc
- (id)deactivationValue:(int)fp8;	// IMP=0x0003bf28
- (void)dealloc;	// IMP=0x0003bb80
- (id)description;	// IMP=0x0003c9d0
- (id)displayIdentifier;	// IMP=0x0003bc08
- (void)exitedAbnormally;	// IMP=0x0003c074
- (void)exitedNormally;	// IMP=0x0003c17c
- (BOOL)expectsFaceContact;	// IMP=0x0003c680
- (BOOL)kill;	// IMP=0x0003c06c
- (BOOL)proximityEventsEnabled;	// IMP=0x0003c7b4
- (void)setAccelerometerDeviceOrientationChangedEventsEnabled:(BOOL)fp8;	// IMP=0x0003c68c
- (void)setAccelerometerRawEventsEnabled:(BOOL)fp8;	// IMP=0x0003c6f4
- (void)setActivationSetting:(int)fp8 flag:(BOOL)fp12;	// IMP=0x0003bc44
- (void)setActivationSetting:(int)fp8 value:(id)fp12;	// IMP=0x0003bc70
- (void)setAutoDimTime:(float)fp8;	// IMP=0x0003c548
- (void)setAutoLockTime:(float)fp8;	// IMP=0x0003c60c
- (void)setDeactivationSetting:(int)fp8 flag:(BOOL)fp12;	// IMP=0x0003be0c
- (void)setDeactivationSetting:(int)fp8 value:(id)fp12;	// IMP=0x0003be48
- (void)setExpectsFaceContact:(BOOL)fp8;	// IMP=0x0003c614
- (void)setProximityEventsEnabled:(BOOL)fp8;	// IMP=0x0003c75c
- (void)setShowsProgress:(BOOL)fp8;	// IMP=0x0003c7c4
- (void)setSystemVolumeHUDEnabled:(BOOL)fp8 forCategory:(id)fp12;	// IMP=0x0003c7ec
- (void)setTouchPointsAllowed:(BOOL)fp8;	// IMP=0x0003c974
- (BOOL)showSystemVolumeHUDForCategory:(id)fp8;	// IMP=0x0003c910
- (BOOL)showsProgress;	// IMP=0x0003c7dc
- (int)statusBarMode;	// IMP=0x0003c3c0
- (int)statusBarOrientation;	// IMP=0x0003c450
- (BOOL)touchPointsAllowed;	// IMP=0x0003c9bc
- (void)updateStatusBar:(float)fp8;	// IMP=0x0003c394
- (void)updateStatusBar:(float)fp8 fence:(int)fp12 animation:(int)fp16;	// IMP=0x0003c264

@end

#endif