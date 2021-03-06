/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray, SBAwayController;

@interface SBAwayModel : NSObject
{
    SBAwayController *_controller;	// 4 = 0x4
    NSMutableArray *_standardVMs;	// 8 = 0x8
    NSMutableArray *_calls;	// 12 = 0xc
    NSMutableArray *_SMSs;	// 16 = 0x10
    NSMutableArray *_otherAwayItems;	// 20 = 0x14
}

- (void)addCall:(struct __CTCall *)fp8;	// IMP=0x00026900
- (void)addOtherAwayItem:(id)fp8;	// IMP=0x0002689c
- (void)addSMSMessage:(struct __CTSMSMessage *)fp8;	// IMP=0x00026984
- (void)dealloc;	// IMP=0x00026780
- (id)initWithController:(id)fp8;	// IMP=0x00026738
- (void)markAwayTime;	// IMP=0x000267f8
- (id)missedItems;	// IMP=0x00027644
- (void)populateWithMissedCalls:(id)fp8;	// IMP=0x00026c9c
- (void)populateWithMissedEnhancedVoiceMails:(id)fp8;	// IMP=0x00027464
- (void)populateWithMissedSMS:(id)fp8;	// IMP=0x000270b8
- (void)setStandardVoiceMailCount:(int)fp8;	// IMP=0x0002785c
- (int)uncoalescedMissedItemCount;	// IMP=0x00027774

@end

