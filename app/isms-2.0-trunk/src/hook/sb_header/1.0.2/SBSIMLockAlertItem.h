/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertItem.h"

@interface SBSIMLockAlertItem : SBAlertItem
{
    int _status;	// 12 = 0xc
}

- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x00061a14
- (id)alertText;	// IMP=0x0006180c
- (id)alertTitle;	// IMP=0x0006169c
- (BOOL)canUnlock;	// IMP=0x00061684
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x00061acc
- (void)didDeactivate:(BOOL)fp8;	// IMP=0x0006194c
- (void)dismiss;	// IMP=0x0006198c
- (id)lockLabel;	// IMP=0x00061cf8
- (void)performUnlockAction;	// IMP=0x00061a6c
- (int)status;	// IMP=0x00061944
- (void)unlock;	// IMP=0x000619cc

@end

