//==============================================================================
//	Created on 2007-11-24
//==============================================================================
//	$Id: UIMessageTableCell.h 13 2007-11-18 16:33:27Z shawn $
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

/*
 * Copyright WeIPhone Dev Team
 * 
 *
 *
 *   
 *   Rev History: 
 *								  reorg by ChinaET 	2007-10-4
 *    							first version by laoren .
 *
 */

/**
 * Changed by Shawn
 */
#ifndef deviceh
#define deviceh

#ifdef __cplusplus
extern "C" {
#endif

/*int OpenConn();
void CloseConn(int fd);
Boolean ResetConn(int fd);
int ReadResp(int fd);
int SendCmd(int fd, void *buf, size_t size);
*/
typedef void (* CALLBACK) (int);
//int sendmessage(char *phone,char *sms,CALLBACK callback);
int sendmessage(const char *phone,const char *sms,char *code,CALLBACK callback);



/*char * getSMSCNumber(int fd);
Boolean sendsms(int fd,char *atcmd,char *pdu);

void HexDump(unsigned char *buf, int size);
*/

#ifdef __cplusplus
}
#endif
#endif


