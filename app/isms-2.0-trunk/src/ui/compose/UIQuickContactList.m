//==============================================================================
//	Created on 2008-1-3
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

#import "Prefix.h"
#import "UIQuickContactList.h"
#import <UIKit/UIKit.h>
#import <UIKit/UITable.h>
#import <UIKit/UISimpleTableCell.h>
#import <WebCore/WebFontCache.h>
#import <UIKit/UIImageView.h>
#import "SQLiteDB.h"
#import "Contact.h"
#import "Log.h"
#import <UIKit/UIValueButton.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITextLabel.h>

#ifdef __BUILD_FOR_2_0__
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIImage-UIImagePrivate.h>
#endif

@class UIQuickContactList;
/***************************************************************
 * Customized table cell that holds the row id
 * 
 * @Author Shawn
 ***************************************************************/
static UIImage *iconChecked = nil,*iconUnchecked = nil;

@interface MyTableCell : UIImageAndTextTableCell{
	int rowId;
	BOOL selected;
	id target;
}
-(void)markSelected:(BOOL)flag;
-(void)setTarget:(id)aTarget;
@end

@implementation MyTableCell
-(id)initWithRowId:(int)value{
	self = [super init];
	if(self){
		rowId = value;
		[self setTapDelegate:self];
		[self setImage:iconUnchecked];
	}
	return self;
}

-(void)setTarget:(id)aTarget{
	target = aTarget;
}
- (void)view:(UIView *)view handleTapWithCount:(int)count event:(struct GSEvent *)event{
	if(count == 1){
		LOG(@"Row %d selected",rowId);
		[super setSelected:YES withFade:NO];
		[super setSelected:NO withFade:YES];
		[self markSelected:!selected];
	}
	else if(count == 2){
		//TODO direct use this content
		LOG(@"Row %d is double tapped",rowId);
		[self markSelected:YES];
		[(UIQuickContactList*)target onFinishContactSelect];
	}
}

-(BOOL)selected{
	return selected;
}

-(void)markSelected:(BOOL)flag{
	LOG(@"markSelected:%d",flag);
	selected = flag;
	if(selected){
		[self setImage:iconChecked];
	}else{
		[self setImage:iconUnchecked];
	}
}
@end


/***************************************************************
 * UIQuickContactList class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation UIQuickContactList
- (id)initWithFrame:(struct CGRect)frame {
	self=[super initWithFrame: frame];
	if(self == nil) {
		return nil;
	}
	
	CGRect rect = [self bounds];
	
	UIImage *bgImg = [UIImage applicationImageNamed:@"bg_quick_contact_list.png"];
	//UIImage *bgImg = [UIImage applicationImageNamed:@"bg_compose_area.png"];
	bgView = [[UIImageView alloc]initWithImage:bgImg];
	[bgView setFrame:rect];
	[self addSubview:bgView];
	
	// Init the icons
	iconChecked = [UIImage applicationImageNamed:@"icon_checked.png"];
	iconUnchecked = [UIImage applicationImageNamed:@"icon_unchecked.png"];
	                 
	// Init table
	float transparentColor[4] = {0, 0, 0, 0};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	struct CGColor *color = CGColorCreate(colorSpace, transparentColor);

	table = [[UITable alloc] initWithFrame: rect];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"contacts" identifier:@"contacts" width: frame.size.width ];
	[table addTableColumn: col];
	[table setSeparatorStyle: 1];
	[table setDelegate: self];
	[table setDataSource: self];

#ifdef __BUILD_FOR_2_0__
	[table setBackgroundColor:[UIColor colorWithCGColor:color]];
#else
	[table setBackgroundColor:color];
#endif

	[table setShowScrollerIndicators:YES];
	[table setReusesTableCells:YES];
	//[table reloadData];
	//[table setShowBackgroundShadow:YES];
	
	[table setAccessoryView:[self _createTableAccessoryView]];
	
	[self addSubview: table];
	
	tableCells = [[NSMutableArray alloc] init];

	CGColorRelease(color);
	CGColorSpaceRelease(colorSpace);
	
	[self setUserInteractionEnabled:YES];

	return self;
}

-(UIView*)_createTableAccessoryView{
	UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,49)]; 
	
#ifdef __BUILD_FOR_2_0__
	UIFont * buttonTitleFont = [UIFont systemFontOfSize:18];
#else
	struct __GSFont *buttonTitleFont=[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:18];
#endif

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float transparentColor[4] = {0, 0, 0, 0};
	float titleColor[4] = {0.3, 0.3, 0.3, 1};

	CGColorRef transparentColorRef = CGColorCreate( colorSpace, transparentColor);
	CGColorRef titleColorRef = CGColorCreate( colorSpace, titleColor);

	UIImage* btnImage = [UIImage imageNamed:@"button_light_round_m.png"];
	UIImage* btnImageOn = [UIImage imageNamed:@"button_light_round_m_on.png"];
		
	UIPushButton *btnSelectAll = [[UIPushButton alloc] initWithTitle:NSLocalizedStringFromTable(@"Select All",@"iSMS",@"") autosizesToFit:NO];
	[btnSelectAll setFrame:CGRectMake(40.,(49. - 35.) /2.,100.,35.)];
	[btnSelectAll setStretchBackground:YES];
	[btnSelectAll setBackground:btnImage forState:0]; //up state
	[btnSelectAll setBackground:btnImageOn forState:1]; //down state
#ifdef __BUILD_FOR_2_0__
	[btnSelectAll setBackgroundColor:[UIColor colorWithCGColor:transparentColorRef]];
#else
	[btnSelectAll setBackgroundColor:transparentColorRef];
#endif
	[btnSelectAll setTitleFont:buttonTitleFont];
	[btnSelectAll setEnabled:YES];  //may not be needed
#ifdef __BUILD_FOR_2_0__
	[btnSelectAll setTitleColor:[UIColor colorWithCGColor:titleColorRef] forState:0];
	[btnSelectAll setTitleColor:[UIColor colorWithCGColor:titleColorRef] forState:1];
#else
	[btnSelectAll setTitleColor:titleColorRef forState:0];
	[btnSelectAll setTitleColor:titleColorRef forState:1];
#endif
	[btnSelectAll setDrawContentsCentered:YES];
	[btnSelectAll setShowPressFeedback:YES];
#ifdef __BUILD_FOR_2_0__
	[btnSelectAll addTarget:self action:@selector(onSelectAllContact) forControlEvents:UIControlEventTouchUpInside];
#else
	[btnSelectAll addTarget:self action:@selector(onSelectAllContact) forEvents:kUIControlEventMouseUpInside];
#endif

	UIPushButton *btnFinish = [[UIPushButton alloc] initWithTitle:NSLocalizedStringFromTable(@"Finish",@"iSMS",@"") autosizesToFit:NO];
	[btnFinish setFrame:CGRectMake((320 - 100 - 40),(49. - 35.) /2.,100.,35.)];
	[btnFinish setBackground:btnImage forState:0]; //up state
	[btnFinish setBackground:btnImageOn forState:1]; //down state
#ifdef __BUILD_FOR_2_0__
	[btnFinish setBackgroundColor:[UIColor colorWithCGColor:transparentColorRef]];
#else
	[btnFinish setBackgroundColor:transparentColorRef];
#endif
	[btnFinish setTitleFont:buttonTitleFont];
	[btnFinish setEnabled:YES];  //may not be needed
#ifdef __BUILD_FOR_2_0__
	[btnFinish setTitleColor:[UIColor colorWithCGColor:titleColorRef] forState:0];
	[btnFinish setTitleColor:[UIColor colorWithCGColor:titleColorRef] forState:1];
#else
	[btnFinish setTitleColor:titleColorRef forState:0];
	[btnFinish setTitleColor:titleColorRef forState:1];
#endif
	//[btnFinish setStretchBackground:NO];
	[btnFinish setDrawContentsCentered:YES];
	[btnFinish setShowPressFeedback:YES];
#ifdef __BUILD_FOR_2_0__
	[btnFinish addTarget:self action:@selector(onFinishContactSelect) forControlEvents:UIControlEventTouchUpInside];
#else
	[btnFinish addTarget:self action:@selector(onFinishContactSelect) forEvents:kUIControlEventMouseUpInside];
#endif

	[accessoryView addSubview:btnSelectAll];
	[accessoryView addSubview:btnFinish];
		
#ifdef __BUILD_FOR_2_0__
#else
        CFRelease(buttonTitleFont);
#endif
        CGColorRelease(transparentColorRef);
        CGColorRelease(titleColorRef);
        CGColorSpaceRelease(colorSpace);
        
	return [accessoryView autorelease];
}

-(void)onFinishContactSelect{
	LOG(@"onFinishContactSelect!!");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UIQuickContactList" object:self userInfo:nil];
}

-(void)onSelectAllContact{
	//LOG(@"onSelectAllContact!!");
	[self _selectAllContact:YES];
}

- (void)dealloc {
	RELEASE(table);
	RELEASE(searchResult);
	RELEASE(tableCells);
	RELEASE(bgView);
	[super dealloc];
}

//------------------------------------------------------------
// Table DataSourceDelegate methods
- (BOOL)table:(UITable*)table canSelectRow:(int)row{
	return NO;
}

- (void)reloadData{
	LOG(@"QuickContactList.reloadData() called");
	RELEASE(searchResult);
	RELEASE(tableCells);

	if(searchString && [searchString length]> 0) {
		searchResult = [[Contact searchContactProperty:3 forName:searchString] retain];
		
		//listedContacts = [[Contact searchByPartialName:searchString] retain];
		tableCells = [[NSMutableArray alloc]initWithCapacity:[searchResult count]];
		for(int i = 0;i < [searchResult count];i++){
			[tableCells addObject:[NSNull null]];
		}
	}else{
		[self clearAllData];
	}
	[table reloadData];
}

- (int)numberOfRowsInTable:(UITable *)table {
	return searchResult == nil?0:[searchResult count];
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col reusing:(BOOL)reuse {
//	if(reuse){
//		id aCell  = [tableCells objectAtIndex:row];
//		if(aCell != [NSNull null]){
//			return aCell;
//		}
//	}
	// Always cache the table cell
	id aCell  = [tableCells objectAtIndex:row];
	if(aCell != [NSNull null]){
		return aCell;
	}
	return [self _loadTableCell:row];
}

- (void)tableRowSelected:(NSNotification *)notification {
	LOG(@"Row %d selected, %@",[table selectedRow],notification);
	//[self contactSelected];
	//TODO 
}

-(NSArray*)searchResult{
	return searchResult;
}

/**
 * Create table cell and cache it
 */
-(id)_loadTableCell:(int)row{
	LOG(@"Load cell %d",row);
	MyTableCell *cell = [[MyTableCell alloc] initWithRowId:row];
	[cell setTarget:self];
	NSDictionary* data = [searchResult objectAtIndex:row];
	NSString *pn= [data objectForKey:@"value"];
	NSString *label = [data objectForKey:@"label"];
	NSString *name= [data objectForKey:@"compositeName"];

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float transparentComponents[4] = {0, 0, 0, 0};
	//float grayComponents[4] = {0.55, 0.55, 0.55, 1};
	float textGrayComponents[4] = {0.3, 0.3, 0.3, 1};

	CGColorRef transparentColor = CGColorCreate(colorSpace, transparentComponents);
	CGColorRef textGrayColor = CGColorCreate(colorSpace, textGrayComponents);

	//Create description label
	UITextLabel *nameLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(40.0f, 3.0f, 200.0f, 18.0f)];
	[nameLabel setText:name];
	//	[nameLabel setWrapsText:YES];
#ifdef __BUILD_FOR_2_0__
	[nameLabel setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
#else
	[nameLabel setBackgroundColor:transparentColor];
#endif

	UITextLabel *numLabel = [[UITextLabel alloc] initWithFrame:CGRectMake(40.0f, 21.0f, 280.0f, 20.0f)];
	[numLabel setText:[NSString stringWithFormat:@"%@  %@",label,pn]];
#ifdef __BUILD_FOR_2_0__
	[numLabel setColor:[UIColor colorWithCGColor:textGrayColor]];
	[numLabel setBackgroundColor:[UIColor colorWithCGColor:transparentColor]];
#else
	[numLabel setColor:textGrayColor];
	[numLabel setBackgroundColor:transparentColor];
#endif


	[cell addSubview:nameLabel];
	[cell addSubview:numLabel];
	[tableCells replaceObjectAtIndex:row withObject:cell];
	[cell release];
	return cell;
}

-(void)_selectAllContact:(BOOL)flag{
	for(int i = 0;i < [tableCells count];i++){
		id obj = [tableCells objectAtIndex:i];
		if(obj == [NSNull null]){
			obj = [self _loadTableCell:i];
		}
		MyTableCell* cell = (MyTableCell*)obj;
		[cell markSelected:flag];
	}
}

-(NSArray*)selectedContacts{
	NSMutableArray* result = [[NSMutableArray alloc]init];
	for(int i = 0;i < [tableCells count];i++){
		id obj = [tableCells objectAtIndex:i];
		// If the obj is null, that means the table cell has never been shown,
		// so it should not be selected yet!
		if(obj != [NSNull null]){
			MyTableCell* cell = (MyTableCell*)obj;
			if([cell selected]){
				//Contact* c = [Contact loadById]
				[result addObject:[searchResult objectAtIndex:i]];
			}
		}
	}
	return [result autorelease];
	//return selectedContacts;
}

-(BOOL)hasContactSelected{
	for(int i = 0;i < [tableCells count];i++){
		id obj = [tableCells objectAtIndex:i];
		if(obj != [NSNull null]){
			MyTableCell* cell = (MyTableCell*)obj;
			if([cell selected]){
				return YES;
			}
		}
	}
	return NO;
}

-(void)setSearchString:(NSString *)aString {
	RETAIN(searchString,aString);
	[self reloadData];
}

-(BOOL)hasResults{
	return [searchResult count] > 0;
}

-(void)setVisible:(BOOL) flag{
	visible = flag;
	if(!visible){
		[self removeFromSuperview];
	}
}

-(BOOL)visible{
	return visible;
}

-(void)clearAllData{
	LOG(@"QuickContactList clear all data");
	RELEASE(searchResult);
	RELEASE(tableCells);

	[table clearAllData];
	[table reloadData];
}
@end
