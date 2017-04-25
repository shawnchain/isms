//==============================================================================
//	Created on 2007-12-20
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
#import "UITemplateChooserView.h"

#import "Prefix.h"
#import <UIKit/UINavigationBar.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UISectionList.h>
#import "MessageTemplate.h"
#import "UITableEx.h"
#import <UIKit/UIKit.h>
#import "UITemplateEditView.h"
#import "UIController.h"

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#endif

#import "ISMSComposeViewController.h"
//@interface UITemplateTableCell : UIImageAndTextTableCell
//{
//	BOOL editable;
//}
//-(BOOL)editable;
//@end
//
//@implementation UITemplateTableCell
//-(BOOL)editable{
//	return editable;
//}
//-(void)setEditable:(BOOL)value{
//	editable = value;
//}

//-(BOOL)respondsToSelector:(SEL)sel {
//  BOOL rts = [super respondsToSelector:sel];
//  LOG(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
//  return rts;
//}
//@end

@implementation UITemplateChooserView

-(void)setupNavBarButton:(BOOL) isEditMode {
	if(isEditMode) {
		//[topBar showLeftButton:NSLocalizedStringFromTable(@"Done",@"iSMS",@"") withStyle:3 rightButton:NSLocalizedStringFromTable(@"Add",@"iSMS",@"") withStyle:nil];
		[topBar showLeftButton:NSLocalizedStringFromTable(@"Done",@"iSMS",@"") withStyle:3 rightButton:nil withStyle:0];
	} else {
		[topBar showButtonsWithLeftTitle:NSLocalizedStringFromTable(@"Edit",@"iSMS",@"") rightTitle:NSLocalizedStringFromTable(@"Cancel",@"iSMS",@"") leftBack:NO];
	}
}

- (id)initWithFrame:(struct CGRect)frame {
	DBG(@"Initializing UITemplateChooserView");
	self = [super initWithFrame:frame];
	if(self == nil) {
		return nil;
	}

	// Init data
	RETAIN (templateList,[[MessageTemplate sharedInstance] defaultTemplates]);
	
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
	UINavigationItem *topBarTitle = [[UINavigationItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Template List",@"iSMS",@"")];
	[topBar pushNavigationItem:topBarTitle];
	[self setupNavBarButton:NO];
	[topBar enableAnimation];
	[topBar setDelegate:self];
	[self addSubview:topBar];

	// Initialize the template list
	list = [[UISectionList alloc] initWithFrame:CGRectMake(0.0f, UI_TOP_NAVIGATION_BAR_HEIGHT, frame.size.width, frame.size.height-UI_TOP_NAVIGATION_BAR_HEIGHT)];
	[list setDataSource:self];
	[list reloadData];
	[self addSubview:list];

	table = [list table];
	[table setShouldHideHeaderInShortLists:NO];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"" identifier:@"col0" width: frame.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setRowHeight:44.];

	[table setShowScrollerIndicators:YES];
	[table setAllowSelectionDuringRowDeletion:NO];
	[table setReusesTableCells:NO];
	//[table enableRowDeletion: YES animated: YES];	// Enable deletion

	[table setDelegate:self];
	[table setDataSource:self];

	[self reloadData];
	//[self addSubview: table];
	DBG(@"table done!");

	[self setUserInteractionEnabled:YES];
	return self;
}


//-(BOOL)respondsToSelector:(SEL)sel {
//  BOOL rts = [super respondsToSelector:sel];
//  LOG(@"!!! %@ respondsToSelector \"%@\" (%d)\n",[self class],NSStringFromSelector(sel), rts);
//  return rts;
//}

/*
-(void)setShow:(BOOL)flag {
	//CGRect startFrame,stopFrame;
	if(flag) {
		[parentView addSubview:self];
		[table clearRowSelection];
	} else {
		[table clearRowSelection];
		[self removeFromSuperview];
	}
}
*/

/*
-(void)setParentView:(UIView*)aView {
	parentView = aView;
}
*/

// Reload data and refresh the table
- (void)reloadData {
	[table clearRowSelection];
	[table clearAllData];
	[table reloadData];
}

-(void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button {
	if(button == 0) {
		// Canceled, notify without data
		[[NSNotificationCenter defaultCenter] postNotificationName:TEMPLATE_CHOOSED object:self userInfo:nil];			
	}else if(button == 1){
		//Show the editable list of templates
		if(editViewController == nil){
			editViewController = [[ISMSTemplateEditViewController alloc] initWithNibName:nil bundle:nil];
		}
		[[[[ISMSComposeViewController sharedInstance] navigationController] modalViewController] presentModalViewController:editViewController animated:YES];
		
	}
}

//===============================================
// Table Data Provider callbacks
//===============================================
- (int)numberOfSectionsInSectionList:(UISectionList *)aSectionList {
	// number of sections in this table    
	return 2;
}
        
- (NSString *)sectionList:(UISectionList *)aSectionList titleForSection:(int)section {
	// title of said section
	switch(section){
	case 0:
		return NSLocalizedStringFromTable(@"Customized",@"iSMS",@"");
		break;
	case 1:
		return NSLocalizedStringFromTable(@"Stock",@"iSMS",@"");
		break;
	}
	return @"";
}       
        
- (int)sectionList:(UISectionList *)aSectionList rowForSection:(int)section {
	int customizedTemplateCount = [[[MessageTemplate sharedInstance] customizedTemplates] count];
	// the row that this section begins on
	switch(section){
	case 0:
		return 0;
		break;
	case 1:
		return customizedTemplateCount;
		break;
	}
	return 0;
}

- (int)numberOfRowsInTable:(UITable *)table {
	return [templateList count] + [[[MessageTemplate sharedInstance] customizedTemplates] count];
}

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(struct __GSEvent *)event{
	LOG(@"%@ tapped!",view);
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column reusing:(BOOL)flag {
	if(row < 0){
		return nil;
	}
	UIImageAndTextTableCell *cell = [[UIImageAndTextTableCell alloc]init];
	NSString *title;
	NSArray *customized = [[MessageTemplate sharedInstance] customizedTemplates];
	if(row < [customized count]){
		title = [customized objectAtIndex:row];
	}else{
		title = [templateList objectAtIndex:(row - [customized count])];
	}
	[cell setTitle:title];
	return [cell autorelease];
}

- (UITableCell*)table:(UITable*)atable cellForRow:(int)arow column:(int)acolumn{
	return [self table:atable cellForRow:arow column:acolumn reusing:NO];
}

//===============================================
// Table delegate callbacks
//===============================================
// Selection is not allowed under edit/deletion mode
- (BOOL)table: (UITable *)table canSelectRow: (int)row {
	// Always return yes
	return YES;
}

- (void)tableRowSelected:(NSNotification *)notification {
	
	LOG(@">>> tableRowSelected - %@",[notification object]);
	LOG(@">>> %@",[notification userInfo]);
	int row = [table selectedRow];
	
	if(row == NSNotFound){
		// deselect something ?
		return;
	}
	
	NSString* value;
	NSArray* customized = [[MessageTemplate sharedInstance] customizedTemplates];
	int customizeCount = [customized count];
	if(row < customizeCount ){
		value = [customized objectAtIndex:row];
	}else{
		value = [templateList objectAtIndex:(row - customizeCount)];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:TEMPLATE_CHOOSED object:self userInfo:(id)value];
}


- (BOOL)table: (UITable *)table canDeleteRow: (int)row {
	//Not supported yet
	return NO;
}

- (void)table:(UITable*)table deleteRow:(int)row {
	// NOOP;
}

- (BOOL)table:(UITable *)table showDisclosureForRow:(int)row {
	return NO;
}

-(BOOL)willShow:(NSDictionary*)param{
	[self reloadData];
	return YES;
}

-(void)clearSelection{
	[table clearRowSelection];
}

-(void)dealloc {
	RELEASE(topBar);
	RELEASE(list);
	RELEASE(templateList);
	[super dealloc];
}

@end


@implementation ISMSTemplateChooserViewController
- (void)loadView {
	UIView *view = [[UITemplateChooserView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
	//[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];  
	self.view = view;
}

/*
-(void)viewDidLoad:(BOOL)animated{
	[self.view reloadData];
}
*/

-(void)viewWillAppear:(BOOL)animated{
	[self.view reloadData];
}

@end