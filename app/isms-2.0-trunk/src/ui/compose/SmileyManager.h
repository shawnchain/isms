//==============================================================================
//	Created on 2007-12-18
//==============================================================================
//	$Id: SmileyManager.h 269 2008-09-21 15:40:22Z shawn $
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
#ifndef SMILEYMANAGER_H_
#define SMILEYMANAGER_H_

#import "Prefix.h"

#define SMILEY_LOCATION @"smileys/default"

@interface SmileyManager : NSObject{
	NSMutableDictionary* smileyMap;
	NSMutableDictionary* availableSmileyMap;
}

+(id)sharedInstance;

-(NSDictionary*)allSmileyMap;
-(NSDictionary*)availableSmileyMap;
@end

#endif /*SMILEYMANAGER_H_*/
