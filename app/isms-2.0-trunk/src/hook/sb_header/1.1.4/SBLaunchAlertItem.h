/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertItem.h"

@class SBDisplay;

@interface SBLaunchAlertItem : SBAlertItem
{
    SBDisplay *_associatedDisplay;	// 12 = 0xc
    int _type;	// 16 = 0x10
    BOOL _isDataAlert;	// 20 = 0x14
}

- (void)_displayDeactivated:(id)fp8;	// IMP=0x0006f260
- (id)alertSheet;	// IMP=0x0006f2a0
- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0006f490
- (void)dealloc;	// IMP=0x0006f114
- (BOOL)dismissOnLock;	// IMP=0x0006f298
- (id)initWithLaunchAlertType:(int)fp8 dataAlert:(BOOL)fp12;	// IMP=0x0006f0c4
- (void)setAssociatedWithDisplay:(id)fp8;	// IMP=0x0006f168

@end

