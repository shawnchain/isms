/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlert.h"

@class NSString;

@interface SBCallFailureAlert : SBAlert
{
    int _causeCode;	// 48 = 0x30
    NSString *_address;	// 52 = 0x34
    int _uid;	// 56 = 0x38
    struct __CTCall *_call;	// 60 = 0x3c
}

+ (void)activateForCall:(struct __CTCall *)fp8 causeCode:(long)fp12;	// IMP=0x00059e0c
+ (BOOL)shouldDisplayForCauseCode:(long)fp8;	// IMP=0x00059d90
+ (void)test;	// IMP=0x00059f14
- (void)activateWhenPossible;	// IMP=0x00059da0
- (int)addressBookUID;	// IMP=0x0005a06c
- (id)alertDisplayViewWithSize:(struct CGSize)fp8;	// IMP=0x00059ffc
- (struct __CTCall *)call;	// IMP=0x0005a05c
- (id)callAddress;	// IMP=0x0005a064
- (long)causeCode;	// IMP=0x0005a054
- (void)dealloc;	// IMP=0x00059d2c
- (id)initWithCauseCode:(long)fp8 call:(struct __CTCall *)fp12;	// IMP=0x00059c5c
- (void)setCallAddress:(id)fp8;	// IMP=0x0005a074

@end

