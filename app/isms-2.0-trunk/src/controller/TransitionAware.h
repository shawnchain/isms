//==============================================================================
//	Created on 2007-12-4
//==============================================================================
//	$Id: TransitionAware.h 64 2007-12-13 14:08:15Z shawn $
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
#ifndef TRANSITIONAWARE_H_
#define TRANSITIONAWARE_H_

/***************************************************************
 * Protocol for UI transition callback
 * 
 * @Author Shawn
 ***************************************************************/
@protocol TransitionAware
//@interface TransitionAware(UIView)
-(BOOL)willShow:(NSDictionary*) param;
-(void)didShow:(NSDictionary*) param;
-(BOOL)willHide:(NSDictionary*) param;
-(void)didHide:(NSDictionary*) param;
@end

#endif /*TRANSITIONAWARE_H_*/
