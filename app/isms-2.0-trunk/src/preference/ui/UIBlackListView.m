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
#import "UIBlackListView.h"
#import "ObjectContainer.h"
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITable.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIHardware.h>
#import "BlackList.h"
#import "UIController.h"
#import "UIAddBlackListView.h"
#import "Prefix.h"
#import "UITableEx.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#endif

@implementation UIBlackListView : UIView
//+(void)initialize {
//	[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
//}
//
//+(id)sharedInstance {
//	return [[ObjectContainer sharedInstance] objectForKey:self];
//}

-(id)initWithFrame:(CGRect)rect {
	[super initWithFrame:rect];
	LOG(@"Initializing UIBlackListView");
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
        CGColorRelease(whiteColor);
	CGColorSpaceRelease(colorSpace);

	//topBar = [[UIImageNavigationBar alloc] init];
	topBar = [[UINavigationBar alloc] init];
	[topBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[topBar setBarStyle:3];
	UINavigationItem *topBarTitle = [[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Edit Black List",@"iSMS",@"")];
	[topBar pushNavigationItem:topBarTitle];
	[self _setupNavBarButton:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];

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
	return self;
}

-(void)_setupNavBarButton:(BOOL) isEditMode {
	//style 1 is red
	[topBar showButtonsWithLeftTitle:NSLocalizedStringFromTable(@"Back",@"iSMS",@"")  rightTitle:NSLocalizedStringFromTable(@"Add",@"iSMS",@"") leftBack:YES];
//	[topBar showLeftButton:NSLocalizedStringFromTable(@"Back",@"iSMS",@"") withStyle:0 rightButton:NSLocalizedStringFromTable(@"Add",@"iSMS",@"") withStyle:3];
}

// Reload data and refresh the table
- (void)_reloadData {
	[table clearRowSelection];
	[table clearAllData];
	[table reloadData];
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if(button == 0) {
		// Show the add UI
		if(addBlackListView == nil){
			struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
			rect.origin.x = rect.origin.y = 0.0f;
			addBlackListView = [[UIAddBlackListView alloc] initWithFrame:rect];
			[(UIAddBlackListView*)addBlackListView setDelegate:self];
		}
		UIController *c = [UIController defaultController];
		[c switchToView:addBlackListView from:[c maskView] withStyle:3];
	}else if(button == 1){
		// SWitch back
		[[UIController controllerForName:@"main"] switchBackFrom:self];
	}
}

//===============================================
// Table Data Provider callbacks
//===============================================
-(int) numberOfRowsInTable:(UITable*)table {
	int c = [[BlackList sharedInstance] count];
	LOG(@"Number of rows %d",c);
	return c;
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column reusing:(BOOL)flag {
	LOG(@"Creating cell for row %d",row);
	NSArray *list = [[BlackList sharedInstance] list];
	UIImageAndTextTableCell *cell = [[UIImageAndTextTableCell alloc]init];
	NSString *title = [list objectAtIndex:row];
	[cell setTitle:title];
	//TODO set the block image
	return [cell autorelease];
}

- (UITableCell*)table:(UITable*)atable cellForRow:(int)arow column:(int)acolumn{
	LOG(@"Creating cell for row %d",arow);
	return [self table:atable cellForRow:arow column:acolumn reusing:NO];
}

//===============================================
// Table delegate callbacks
//===============================================
// Selection is not allowed under edit/deletion mode
- (BOOL)table: (UITable *)table canSelectRow: (int)row {
	return NO;
}

- (void)tableRowSelected:(NSNotification *)notification {
	//int row = [table selectedRow];
	//TODO EDIT UI ?
}

- (BOOL)table: (UITable *)table canDeleteRow: (int)row {
	return YES;
}

- (void)table:(UITable*)aTable deleteRow:(int)row {
	LOG(@"delete row %d",row);
	UIImageAndTextTableCell *cell = [table cellAtRow:row column:0];
	NSString* address = [cell title];
	[[BlackList sharedInstance] unblock:address];
	LOG(@"Contact %@/Row(%d) is unblocked",address, row);
}

- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row {
	return NO;
}

- (BOOL)willShow:(NSDictionary*)param{
	[self _reloadData];
	return YES;
}

-(void)dealloc {
	RELEASE(topBar);
	RELEASE(table);
	[super dealloc];
}

@end
