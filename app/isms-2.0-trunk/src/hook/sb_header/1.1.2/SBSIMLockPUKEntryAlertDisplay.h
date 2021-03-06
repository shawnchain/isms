/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBSIMLockEntryAlertDisplay.h"

@class NSString;

@interface SBSIMLockPUKEntryAlertDisplay : SBSIMLockEntryAlertDisplay
{
    int _state;	// 76 = 0x4c
    NSString *_enteredPUKCode;	// 80 = 0x50
    NSString *_newPIN;	// 84 = 0x54
}

- (void)_attemptPUKUnlock;	// IMP=0x0006b178
- (id)_pukAttemptsRemainingLabel;	// IMP=0x0006acdc
- (void)dealloc;	// IMP=0x0006ac7c
- (id)label;	// IMP=0x0006b0b8
- (void)setupFailureState;	// IMP=0x0006af94
- (void)setupSuccess;	// IMP=0x0006addc
- (id)titleText;	// IMP=0x0006aeb8
- (void)unlock;	// IMP=0x0006b190

@end

