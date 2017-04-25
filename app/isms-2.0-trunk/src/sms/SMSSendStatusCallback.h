//==============================================================================
//	Created on 2008-2-13
//==============================================================================
//	$Id: SMSSendStatusCallback.h 170 2008-02-24 15:51:31Z shawn $
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
#ifndef SMSSTATUSCALLBACK_H_
#define SMSSTATUSCALLBACK_H_

@protocol SMSSendStatusCallback
	-(void)willSend:(id)data;
	-(void)sendSuccess:(id)data;
	-(void)sendError:(id)data;
	-(void)taskFinished:(id)data;
@end
#endif /*SMSSTATUSCALLBACK_H_*/
