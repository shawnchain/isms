//==============================================================================
//	Created on 2008-1-20
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
#import "UITemplateEditView.h"
#import <UIKit/UIKit.h>
#import "Prefix.h"
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITable.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITableColumn.h>
#import "MessageTemplate.h"
#import "UIController.h"

#import "UITableEx.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#endif

#import "ISMSComposeViewController.h"

@implementation UITemplateEditView : UIView
- (id)initWithFrame:(struct CGRect)frame {
	LOG(@"Initializing UITemplateEditView");
	self = [super initWithFrame:frame];
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
	[topBar setFrame:CGRectMake(0,0, frame.size.width,UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[topBar setBarStyle:3];
	UINavigationItem *topBarTitle = [[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Edit Templates",@"iSMS",@"")];
	[topBar pushNavigationItem:topBarTitle];
	[self _setupNavBarButton:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];

	// Initialize the list table
	table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, frame.size.width, frame.size.height-UI_TOP_NAVIGATION_BAR_HEIGHT)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"" identifier:@"col0" width: frame.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:44.];

	[table setShowScrollerIndicators:YES];
	[table setAllowSelectionDuringRowDeletion:NO];
	[table setReusesTableCells:NO];

	[table setDelegate:self];
	[table setDataSource:self];

	[self reloadData];
	[self addSubview: table];
	[table enableRowDeletion: YES animated: YES];	// Enable deletion
	DBG(@"table done!");

	return self;
}

-(void)_setupNavBarButton:(BOOL) isEditMode {
	//[topBar showButtonsWithLeftTitle:@nil rightTitle:NSLocalizedStringFromTable(@"Done",@"iSMS",@"") leftBack:NO];
	[topBar showLeftButton:nil withStyle:0 rightButton:NSLocalizedStringFromTable(@"Done",@"iSMS",@"") withStyle:3];
}

// Reload data and refresh the table
- (void)reloadData {
	[table clearRowSelection];
	[table clearAllData];
	[table reloadData];
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if(button == 0) {
		// Canceled, notify without data
		//[[NSNotificationCenter defaultCenter] postNotificationName:TEMPLATE_CHOOSED object:self userInfo:nil];
		//[[UIController controllerForName:@"compose"] switchBackFrom:self];
		[[[[ISMSComposeViewController sharedInstance]navigationController] modalViewController] dismissModalViewControllerAnimated:YES];
	}
}

//===============================================
// Table Data Provider callbacks
//===============================================
-(int) numberOfRowsInTable:(UITable*)table {
	int c = [[[MessageTemplate sharedInstance] customizedTemplates] count];
	LOG(@"Number of rows %d",c);
	return c;
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column reusing:(BOOL)flag {
	LOG(@"Creating cell for row %d",row);
	NSArray *customized = [[MessageTemplate sharedInstance] customizedTemplates];
	if(row < [customized count]){
		UIImageAndTextTableCell *cell = [[UIImageAndTextTableCell alloc]init];
		NSString *title = [customized objectAtIndex:row];
		[cell setTitle:title];
		return [cell autorelease];
	}
	return nil;
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

- (void)table:(UITable*)table deleteRow:(int)row {
	[[MessageTemplate sharedInstance] removeTemplateAtIndex:row];
	LOG(@"Row %d is deleted",row);
}

- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row {
	return NO;
}

- (BOOL)willShow:(NSDictionary*)param{
	[self reloadData];
	return YES;
}

-(void)dealloc {
	RELEASE(topBar);
	RELEASE(table);
	[super dealloc];
}
@end

@implementation ISMSTemplateEditViewController
- (void)loadView {
	UIView *view = [[UITemplateEditView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
	//[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];  
	self.view = view;
}

-(void)viewWillAppear:(BOOL)animated{
	[self.view reloadData];
}
@end
