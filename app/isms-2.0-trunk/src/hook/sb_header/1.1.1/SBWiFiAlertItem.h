/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertItem.h"

@class NSDictionary, NSMutableArray, NSString, NSTimer, UITable;

@interface SBWiFiAlertItem : SBAlertItem
{
    NSMutableArray *_networks;	// 12 = 0xc
    NSTimer *_scanTimer;	// 16 = 0x10
    UITable *_table;	// 20 = 0x14
    struct CGSize _size;	// 24 = 0x18
    int _joinRow;	// 32 = 0x20
    NSString *_password;	// 36 = 0x24
    NSDictionary *_joinDict;	// 40 = 0x28
    SBAlertItem *_childAlert;	// 44 = 0x2c
    BOOL _selectingRow;	// 48 = 0x30
    BOOL _storedPassword;	// 49 = 0x31
    BOOL _passwordFailed;	// 50 = 0x32
}

- (void)_enableTable;	// IMP=0x0006d010
- (int)_joinRow;	// IMP=0x0006c400
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0006d8d0
- (BOOL)allowMenuButtonDismissal;	// IMP=0x0006da5c
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x0006decc
- (void)dealloc;	// IMP=0x0006d7dc
- (id)deletionSetForLostNetworks:(id)fp8 originalNetworks:(id)fp12;	// IMP=0x0006c734
- (void)didDeactivate:(BOOL)fp8;	// IMP=0x0006e11c
- (void)didPresentAlertSheet:(id)fp8;	// IMP=0x0006d560
- (void)dismiss;	// IMP=0x0006d034
- (BOOL)dismissOnLock;	// IMP=0x0006e114
- (id)init;	// IMP=0x0006c2ac
- (id)insertionsForNewNetworks:(id)fp8;	// IMP=0x0006c5ec
- (int)numberOfRowsInTable:(id)fp8;	// IMP=0x0006da80
- (void)passwordEntered:(id)fp8;	// IMP=0x0006d668
- (void)performUnlockAction;	// IMP=0x0006da64
- (void)scan;	// IMP=0x0006c250
- (void)setChildAlert:(id)fp8;	// IMP=0x0006c5e4
- (void)setNetworks:(id)fp8;	// IMP=0x0006c4bc
- (id)table:(id)fp8 cellForRow:(int)fp12 column:(id)fp16;	// IMP=0x0006daa0
- (void)tableSelectionDidChange:(id)fp8;	// IMP=0x0006db5c
- (void)wifiManager:(id)fp8 joinCompleted:(int)fp12;	// IMP=0x0006d210
- (void)wifiManager:(id)fp8 scanCompleted:(id)fp12;	// IMP=0x0006c8e0
- (void)willActivate;	// IMP=0x0006d1a0
- (void)willDeactivate:(BOOL)fp8;	// IMP=0x0006d128

@end

