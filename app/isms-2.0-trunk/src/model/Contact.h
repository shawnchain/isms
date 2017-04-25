//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: template.txt 11 2007-11-18 05:35:36Z shawn $
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================


#import "Prefix.h"
#import "Entity.h"

typedef enum{
	PROP_TYPE_PHONE = 3,
	PROP_TYPE_EMAIL = 4
}PropertyType;

/***************************************************************
 * ContactProperty
 * 
 * @Author Shawn
 ***************************************************************/
@interface ContactProperty : NSObject
{
	NSString *label;
	NSString *value;
}

-(NSString*)label;
-(NSString*)value;

-(id)initWithValue:(NSString*)aValue forLabel:(NSString*)aLabel;

@end

/***************************************************************
 * Contact Class
 * 
 * @Author Shawn
 ***************************************************************/
@interface Contact : NSObject <Entity>
{
	NSString *rowId;
	NSString *firstName;
	NSString *lastName;
	NSString *phoneNumber;
}

//+(Contact*) loadById:(NSString*) aID;
+(Contact*) loadByNumber:(NSString*) number;

+(NSArray*) searchContactProperty:(PropertyType)type forName:(NSString*)name;

//FIXME deprecated
+(NSArray*) searchByPartialName:(NSString*) name;
+(NSString *)getNameByPhoneNumber:(NSString*)aNum;

-(NSString *)getId;
-(NSString *)firstName;
-(NSString *)lastName;
-(NSString *)phoneNumber;
-(NSString *)compositeName;
/*
-(void)setId:(NSString*) value;
-(void)setFirstName:(NSString*)value;
-(void)setLastName:(NSString*)value;
-(void)setPhoneNumber:(NSString*)value;
*/

// New methods tobe added
// getCompositeName;
// getPropertiesForType:(int)type;
// getProperties();

-(id)initWithRowData:(NSDictionary*) row; 

@end