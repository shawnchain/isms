//==============================================================================
//	Created on 2008-4-21
//==============================================================================
//	$Id: ISMS_SBTelephonyManager.h 209 2008-04-21 18:40:59Z shawn $
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS-1.0-trunk.
//
//  iSMS-1.0-trunk is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS-1.0-trunk is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS-1.0-trunk.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#ifndef ISMS_SBTELEPHONYMANAGER_H_
#define ISMS_SBTELEPHONYMANAGER_H_

#import "SBTelephonyManager.h"

/***************************************************************
 * SBTelephonyManager Hookup class
 * 
 * @Author Shawn
 ***************************************************************/
@interface ISMS_SBTelephonyManager : SBTelephonyManager
{}

-(void)_receivedMessage:(struct __CTSMSMessage *)msg;
@end

#endif /*ISMS_SBTELEPHONYMANAGER_H_*/
