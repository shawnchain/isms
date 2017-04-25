//==============================================================================
//	Created on 2008-1-18
//==============================================================================
//	$Id: DBAdapter.h 129 2008-01-18 10:03:22Z shawn $
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
#ifndef DBADAPTER_H_
#define DBADAPTER_H_

#import "ObjectAdapter.h"

@class NSString,NSDictionary;
/***************************************************************
 * DB Adapter that helps instantiate DB objects
 * 
 * @Author Shawn
 ***************************************************************/
@interface DBAdapter : ObjectAdapter
{
	NSString		*mainDB;
	NSDictionary	*attachedDBs;
}

-(id)initWithClass:(Class)clazz mainDB:(NSString*)mainDB attachedDBs:(NSDictionary*) dbs isSingleton:(BOOL)flag;
-(id)newInstance;
@end
#endif /*DBADAPTER_H_*/
