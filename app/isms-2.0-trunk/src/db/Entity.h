//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: Entity.h 150 2008-01-29 16:04:35Z shawn $
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

#ifndef ENTITY_H_
#define ENTITY_H_

#import <Foundation/Foundation.h>
#import "Criteria.h"

@protocol Entity
-(id) initWithRowData:(NSDictionary*) row;
//-(BOOL) save;
//-(BOOL) delete;
@end

#endif /*ENTITY_H_*/
