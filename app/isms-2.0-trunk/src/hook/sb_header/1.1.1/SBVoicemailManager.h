/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@interface SBVoicemailManager : NSObject
{
    CDAnonymousStruct1 _alertMark;	// 4 = 0x4
    CDAnonymousStruct1 _awayItemMark;	// 20 = 0x14
    BOOL _hasVisualVoicemail;	// 36 = 0x24
    int _visualVoicemailSubscriptionToken;	// 40 = 0x28
}

+ (id)sharedInstance;	// IMP=0x00074ed0
- (void)_handleVoicemailAvailableNotification:(id)fp8;	// IMP=0x000753ac
- (void)_handleVoicemailStoreChangedNotification;	// IMP=0x00075574
- (BOOL)_hasVisualVoicemail;	// IMP=0x00075068
- (void)_mark:(CDAnonymousStruct1 *)fp8;	// IMP=0x00075070
- (void)_presentAlertForRecord:(void *)fp8 visualVoicemail:(BOOL)fp12;	// IMP=0x000751b4
- (void)_updateVisualVoicemailState;	// IMP=0x00075024
- (id)copyVisualVoicemailRecordsForAwayItems;	// IMP=0x00075174
- (void)dealloc;	// IMP=0x00074e30
- (id)init;	// IMP=0x00074d48
- (void)mark;	// IMP=0x00075140
- (void)markForAlerts;	// IMP=0x00075100
- (void)markForAwayItems;	// IMP=0x00075120
- (void)setHasVisualVoicemail:(BOOL)fp8;	// IMP=0x00074f34

@end

