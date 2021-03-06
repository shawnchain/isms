/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBRingingAlertItem.h"

@class Alarm;

@interface SBAlarmAlertItem : SBRingingAlertItem
{
    Alarm *_alarm;	// 20 = 0x14
    BOOL _snoozeAlarm;	// 24 = 0x18
}

- (id)alarm;	// IMP=0x00069320
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x000696d8
- (BOOL)allowsSnooze;	// IMP=0x00069328
- (id)avAudioCategory;	// IMP=0x000696cc
- (id)avClientName;	// IMP=0x000696c0
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x00069424
- (void)dealloc;	// IMP=0x00069284
- (id)initWithAlarm:(id)fp8;	// IMP=0x00069244
- (id)lockLabel;	// IMP=0x000693c8
- (void)setAlarm:(id)fp8;	// IMP=0x000692d8
- (id)soundIdentifier;	// IMP=0x00069694
- (void)startSnoozingAndDeactivate;	// IMP=0x00069358

@end

