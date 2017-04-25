//==============================================================================
//	Created on 2008-1-30
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2007>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS.
//
//  iSMS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "UIAddBlackListView.h"
#import "Prefix.h"

#import "ObjectContainer.h"
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITable.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesControlTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesDeleteTableCell.h>
#import "BlackList.h"
#import "UIController.h"
#import "Prefix.h"
#import "UIBlackListView.h"
#import <UIKit/UITextLabel.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#endif

@implementation UIAddBlackListView : UIView
-(id)initWithFrame:(CGRect)rect{
	[super initWithFrame:rect];
	LOG(@"Initializing UIAddBlackListView");
	self = [super initWithFrame:rect];
	if(self == nil) {
		return nil;
	}

	// BG color - WHITE
	float c[4] = {1.0, 1.0, 1.0, 1.0};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *whiteColor = CGColorCreate(colorSpace, c);
#ifdef __BUILD_FOR_2_0__
	[self setBackgroundColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[self setBackgroundColor:whiteColor];
#endif
	//topBar = [[UIImageNavigationBar alloc] init];
	topBar = [[UINavigationBar alloc] init];
	[topBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[topBar setBarStyle:3];
	UINavigationItem *topBarTitle = [[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Add to Black List",@"iSMS",@"")];
	[topBar pushNavigationItem:topBarTitle];
	[self _setupNavBarButton:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];

	textCell = [[UIPreferencesTextTableCell alloc] init];
	[textCell setTitle:NSLocalizedStringFromTable(@"Phone Number",@"iSMS",@"")];
	//[[textCell textField]setText:@"Foo"];
	//[[textCell textField]setAutoCapsType:0];
	//[[textCell textField] setSecure:NO];
	//[[textCell textField] setAutoCapsType:NO];
#ifdef __BUILD_FOR_2_0__
	[[textCell textField] setKeyboardType:6];
#else
	[[textCell textField] setPreferredKeyboardType:6];
#endif
 
	buttonCell = [[UIPreferencesDeleteTableCell alloc] initWithFrame:CGRectMake(0., 0., 320., [UIPreferencesDeleteTableCell defaultHeight])];
	[buttonCell setTitle:NSLocalizedStringFromTable(@"Add",@"iSMS",@"")];

	UITextLabel *label = [buttonCell titleTextLabel];
#ifdef __BUILD_FOR_2_0__
	[label setColor:[UIColor colorWithCGColor:whiteColor]];
#else
	[label setColor:whiteColor];
#endif

	[buttonCell setAlignment:2];

#ifdef __BUILD_FOR_2_0__
	[[buttonCell button] addTarget:self action:@selector(onAddToBlackList) forControlEvents:UIControlEventTouchUpInside];
#else
	[[buttonCell button] addTarget:self action:@selector(onAddToBlackList) forEvents:kUIControlEventMouseUpInside];
#endif
	
	table = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, 320.0f, 460.0 - UI_TOP_NAVIGATION_BAR_HEIGHT )];
	[table setDataSource:self];
	[table setDelegate:self];
	[table reloadData];
	
	[self addSubview:table];

        CGColorRelease(whiteColor);
	CGColorSpaceRelease(colorSpace);

	/*
	// Initialize the list table
	table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, rect.size.width, rect.size.height-UI_TOP_NAVIGATION_BAR_HEIGHT)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"" identifier:@"col0" width: rect.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:44.];

	[table setShowScrollerIndicators:YES];
	[table setAllowSelectionDuringRowDeletion:NO];
	[table setReusesTableCells:NO];

	[table setDelegate:self];
	[table setDataSource:self];

	//[self _reloadData];
	[self addSubview: table];
	[table enableRowDeletion: YES animated: YES]; // Enable deletion
	DBG(@"table done!");
	*/
	return self;
}


-(void)_setupNavBarButton:(BOOL) isEditMode {
	//style 1 is red
	[topBar showLeftButton:nil withStyle:0 rightButton:NSLocalizedStringFromTable(@"Cancel",@"iSMS",@"") withStyle:3];
}

// Reload data and refresh the table
- (void)_reloadData {
//	[table clearRowSelection];
//	[table clearAllData];
//	[table reloadData];
}


#pragma mark ---------------Datasource Methods---------------

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
	return 2;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	if(group == 0){
		// The text box
		return 1;
	}else if(group == 1){
		// The add button
		return 1;
	}
	return 0;
}

//- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
//{
//	UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
//	[cell setTitle:[NSString stringWithFormat:@"CEll for group %d",group]];
//	return [cell autorelease];
//}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForRow:(int)row inGroup:(int)group
{
	UIPreferencesControlTableCell *cell = nil; 
	if(group == 0){
		switch(row){
			case 0:{
				return textCell;
				break;
			}
		}
	}else if(group == 1){
		switch(row){
			case 0:{
				return buttonCell;
				break;
			}
		}
	}
	
	return [cell autorelease];	
}


-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if(button == 0){
		// SWitch back
		[[UIController defaultController] switchBackFrom:self];
	}
}

#pragma mark ---------------Button Callback---------------

-(void)onAddToBlackList{
	NSString* s = [[textCell textField] text];
	if(s == nil || [s length] == 0){
		DBG(@"Number to be blocked is null!");
		return;
	}
	[[BlackList sharedInstance]block:s];
	[(UIBlackListView*)delegate _reloadData];
	[[UIController defaultController] switchBackFrom:self];
}

#pragma mark ---------------UIController Callback---------------
-(BOOL)willShow:(NSDictionary*)param{
	[[textCell textField] setText:@""];
	return YES;
}


-(void)setDelegate:(id)aDelegate{
	delegate = aDelegate;
}

-(id)delegate{
	return delegate;
}

-(void)dealloc{
	RELEASE(topBar);
	RELEASE(table);
	RELEASE(textCell);
	RELEASE(buttonCell);
	[super dealloc];
}
@end
