/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertItem.h"

@interface SBLowPowerAlertItem : SBAlertItem
{
    unsigned int _talkMinutesLeft;	// 12 = 0xc
    unsigned int _talkLevel;	// 16 = 0x10
}

+ (BOOL)_shouldIgnoreChangeToBatteryLevel:(unsigned int)fp8;	// IMP=0x0006bf7c
+ (unsigned int)_thresholdForLevel:(unsigned int)fp8;	// IMP=0x0006bf44
+ (void)saveLowBatteryLog;	// IMP=0x0006b558
+ (void)savePowerDiagnosisLogWithCurrentCapacity:(int)fp8 startCapacity:(int)fp12;	// IMP=0x0006ba78
+ (void)setBatteryLevel:(unsigned int)fp8;	// IMP=0x0006c014
+ (id)systemVersionDescription;	// IMP=0x0006b3f0
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0006c3fc
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x0006c278
- (id)initWithTalkTimeLeft:(unsigned int)fp8 level:(unsigned int)fp12;	// IMP=0x0006bef4
- (BOOL)shouldShowInEmergencyCall;	// IMP=0x0006c44c
- (BOOL)shouldShowInLockScreen;	// IMP=0x0006c444
- (BOOL)undimsScreen;	// IMP=0x0006c454
- (void)willPresentAlertSheet:(id)fp8;	// IMP=0x0006c260

@end
