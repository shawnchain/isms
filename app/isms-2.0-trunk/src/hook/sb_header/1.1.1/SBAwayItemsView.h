/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "UIAlertSheet.h"

@class NSArray;

@interface SBAwayItemsView : UIAlertSheet
{
    NSArray *_displayedItems;	// 96 = 0x60
    float _widestLabel;	// 100 = 0x64
}

+ (struct __GSFont *)createItemTypeFont;	// IMP=0x00037cb8
- (void)dealloc;	// IMP=0x00037c64
- (void)drawItems;	// IMP=0x000380ac
- (void)drawRect:(struct CGRect)fp8;	// IMP=0x00038394
- (BOOL)hasAwayItems;	// IMP=0x00038084
- (id)init;	// IMP=0x00037c08
- (BOOL)reloadData;	// IMP=0x00037e7c

@end

