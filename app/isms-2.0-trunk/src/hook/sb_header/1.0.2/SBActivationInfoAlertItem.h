/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBDismissOnlyAlertItem.h"

@interface SBActivationInfoAlertItem : SBDismissOnlyAlertItem
{
}

+ (id)activeItem;	// IMP=0x0006dc70
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x0006d868
- (void)didDeactivate:(BOOL)fp8;	// IMP=0x0006dc40
- (void)willActivate;	// IMP=0x0006dbfc
- (BOOL)willShowInAwayItems;	// IMP=0x0006d860

@end
