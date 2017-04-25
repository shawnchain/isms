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
 * Enhanced by Shawn
 *   1. Support large text
 *   2. Support message received notification
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <paths.h>
#include <termios.h>
#include <sysexits.h>
#include <sys/param.h>
#include <sys/select.h>
#include <sys/time.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include "encode.h"
#include "device.h"

#define LOG stdout

#define BUFSIZE 4096
char readbuf[BUFSIZE];

struct termios term, gOriginalTTYAttrs;

//#define DEBUG_ENABLED 1

#ifndef DEBUG_ENABLED
#define DEBUGLOG(x) 
#else
#define DEBUGLOG(x) x
#endif

#ifdef DEBUG_ENABLED

void HexDumpLine(unsigned char *buf, int remainder, int offset) {
	int i = 0;
	char c = 0;

	// Print the hex part
	fprintf(LOG, "%08x | ", offset);
	for (i = 0; i < 16; ++i) {
		if (i < remainder)
			fprintf(LOG, "%02x%s", buf[i], (i == 7) ? "  " : " ");
		else
			fprintf(LOG, "  %s", (i == 7) ? "  " : " ");
	}
	// Print the ascii part
	fprintf(LOG, " | ");
	for (i = 0; i < 16 && i < remainder; ++i) {
		c = buf[i];
		if (c >= 0x20 && c <= 0x7e)
			fprintf(LOG, "%c%s", c, (i == 7) ? " " : "");
		else
			fprintf(LOG, ".%s", (i == 7) ? " " : "");
	}

	fprintf(LOG, "\n");
}

void HexDump(unsigned char *buf, int size) {
	int i = 0;

	for (i = 0; i < size; i += 16)
		HexDumpLine(buf + i, size - i, i);
	fprintf(LOG, "%08x\n", size);
}
#endif

int SendCmd(int fd, void *buf, size_t size) {
	DEBUGLOG(fprintf(LOG, "Sending:\n"));
	DEBUGLOG(HexDump((unsigned char*)buf, size));

	int retcode=write(fd, buf, size);
	if (retcode == -1) {
		DEBUGLOG(fprintf(stderr, "Shit. %s\n", strerror(errno)));
		return -1;
	}
	return retcode;
}

int ReadRawResp(int fd) {
	int len = 0;
	struct timeval timeout;
	int nfds = fd + 1;
	fd_set readfds;

	FD_ZERO(&readfds);
	FD_SET(fd, &readfds);

	// Wait a second
	timeout.tv_sec = 0;
	timeout.tv_usec = 500000;

	while (select(nfds, &readfds, NULL, NULL, &timeout) > 0)
		len += read(fd, readbuf + len, BUFSIZE - len);

	if (len > 0) {
		DEBUGLOG(fprintf(LOG, "Read:\n"));
		DEBUGLOG(HexDump((unsigned char *)readbuf, len));
	}
	return len;
}

int stripEcho(int len) {
	char *pStart;

	//strip echo\r\n
	pStart=readbuf;

	do {
		if ((*pStart=='\r') && (*(pStart+1)=='\n'))
			break;
		pStart++;
	} while ((pStart-readbuf)<len);
	pStart++;
	pStart++;
	strcpy(readbuf, pStart);
	return strlen(readbuf);
}

int stripEndOK(int len) {
	char *pEnd;

	pEnd=readbuf+len-1;

	//strip \r\n\r\nOK\r\n
	do {
		if ((*pEnd=='O') && (*(pEnd+1)=='K'))
			break;
		pEnd--;
	} while ((readbuf+len-1-pEnd)<len);

	do {
		pEnd--;
		pEnd--;
	} while (((*pEnd=='\r') && (*(pEnd+1)=='\n')));
	pEnd++;
	pEnd++;
	*pEnd='\0';

	return strlen(readbuf);
}

int ReadResp(int fd) {
	int len;
	len=ReadRawResp(fd);
	if (len > 0) {
		DEBUGLOG(fprintf(LOG, "Read:\n"));
		DEBUGLOG(HexDump((unsigned char *)readbuf, len));
	}
	if (len>0)
		return stripEcho(len);
}

void CloseConn(int fd) {
	if (tcdrain(fd) == -1) {
		DEBUGLOG(printf("Error waiting for drain - %s(%d).\n",
						strerror(errno), errno));
	}

	if (tcsetattr(fd, TCSANOW, &gOriginalTTYAttrs) == -1) {
		DEBUGLOG(printf("Error resetting tty attributes - %s(%d).\n",
						strerror(errno), errno));
	}

	close(fd);
}

#define kATCommandString	"AT\r"
#define kOKResponseString	"OK\r\n"
#define kNumRetries 		100

Boolean ResetConn(int fd, CALLBACK callback) {
	int numBytes; // Number of bytes read or written 
	int i, callback_count=0;
	Boolean result=false;

	for (i = 1; i <= 100; i++) {
		numBytes=SendCmd(fd, kATCommandString, strlen(kATCommandString));

		if ((numBytes==-1)||(numBytes<strlen(kATCommandString)))
			continue;
		if (!ReadResp(fd))
			continue;

		if (strncmp((char *)readbuf, kOKResponseString,
				strlen(kOKResponseString)) == 0) {
			result = true;
			break;
		}
		callback_count=i/10;
		callback(10+callback_count);
	}
	return result;
}

int OpenConn(CALLBACK callback) {
	int fd = open("/dev/tty.debug", O_RDWR | 0x20000 | O_NOCTTY);

	unsigned int handshake = TIOCM_DTR | TIOCM_RTS | TIOCM_CTS | TIOCM_DSR;

	if (fd == -1) {
		DEBUGLOG(fprintf(LOG, "%i(%s)\n", errno, strerror(errno)));
		exit(1);
	}

	// save orig attrib


	cfmakeraw(&gOriginalTTYAttrs);
	gOriginalTTYAttrs.c_cc[VMIN] = 0;
	gOriginalTTYAttrs.c_cc[VTIME] = 0;

	speed_t speed =115200;

	fcntl(fd, 4, 0);
	tcgetattr(fd, &term);

	cfsetspeed(&term, speed);
	cfmakeraw(&term);
	term.c_cc[VMIN] = 0;
	term.c_cc[VTIME] = 5;

	term.c_cflag = (term.c_cflag & ~CSIZE) | CS8;
	term.c_cflag &= ~PARENB;
	term.c_lflag &= ~ECHO;

	tcsetattr(fd, TCSANOW, &term);

	ioctl(fd, TIOCSDTR);
	ioctl(fd, TIOCCDTR);
	ioctl(fd, TIOCMSET, &handshake);

	//now tty has been opened
	callback(10);
	if (ResetConn(fd, callback))
		return fd;
	else {
		CloseConn(fd);
		return -1;
	}
}

Boolean sendsms(int fd, char *atcmd, char *pdu) {
	int numBytes, len, i;
	char RespString[128];
	int tries=50;

	DEBUGLOG(printf("sendsms() called\n"));
	for (i=0; i<tries; i++) {
		numBytes=SendCmd(fd, atcmd, strlen(atcmd));
		if ((numBytes==-1)||(numBytes<10)) {
			DEBUGLOG(printf("send atcmd sms error\n"));
			return false;
		}

		sprintf(RespString, "%s%c", atcmd, '>');
		len=ReadRawResp(fd);

		if (strncmp((char *)readbuf, RespString, strlen(RespString) )== 0)
			break;
		sleep(1);
	};

	numBytes=SendCmd(fd, pdu, strlen(pdu));
	if ((numBytes==-1)||(numBytes<10)) {
		DEBUGLOG(printf("send sms pdu error\n"));
		return false;
	}

	len=ReadRawResp(fd);
	DEBUGLOG(HexDump((unsigned char *)readbuf,len));
	char *p=strstr(readbuf, "ERROR");
	if (NULL!=p)
		return false;

	return true;
}

char * getSMSCNumber(int fd) {
	int numBytes, len;

	char *pStart, *pEnd;
	DEBUGLOG(printf("getSMSCNumber()\n"));

	numBytes=SendCmd(fd, "AT+CSCA?\r", 10);

	if ((numBytes==-1)||(numBytes<10)) {
		DEBUGLOG(printf("send at+csca error\n"));
		return NULL;
	}

	len=ReadResp(fd);
	if (len<=0) {
		DEBUGLOG(fprintf(stderr, "failed to get response\n"));
		return NULL;
	}
	stripEndOK(strlen(readbuf));
	//now in readbuf, like   +CSCA: "8613800519500",145
	//next is striped  unused,got smsc number

	pStart=readbuf;

	do {
		if (*pStart=='\"')
			break;
		pStart++;
	} while ((pStart-readbuf)<len);
	pStart++;
	pEnd=pStart;

	do {
		if (*pEnd=='\"')
			break;
		pEnd++;
	} while ((pEnd-readbuf)<len);
	*pEnd='\0';
	if (*pStart=='+')
		pStart++; //strip first +
	strcpy(readbuf, pStart);
	return (char *)readbuf;
}

void NOOP_CALLBACK(int process) {
	DEBUGLOG(printf("NOOP_CALLBACK - Progress %d\n",process));
}

#define MAX_PHONE_NUMBER_LENGTH 512
#define MAX_SMS_LENGTH 8192

int sendmessage(const char *aphone, const char *asms, char *code,
		CALLBACK callback) {
	char *_sms_text, *_receiver_number;
	size_t _sms_text_len, _receiver_number_len;

	int fd, phonecount, smscount, i, j, callback_count, callback_step;
	char esmsc[128], ephone[128], esms[512/*12+70*4+1*/];
	char *pdu, *atcmd;
	int result = 0;

	if (callback == NULL) {
		callback = NOOP_CALLBACK;
	}
	// Check phone/number and copy to local buffer
	if (aphone == NULL || asms == NULL || code == NULL) {
		return -1;
	}
	_receiver_number_len = strlen(aphone);
	if (_receiver_number_len > MAX_PHONE_NUMBER_LENGTH) {
		_receiver_number_len = MAX_PHONE_NUMBER_LENGTH;
	}
	_receiver_number = malloc(_receiver_number_len + 1);
	snprintf(_receiver_number, _receiver_number_len + 1, "%s", aphone);

	_sms_text_len = strlen(asms);
	if (_sms_text_len > MAX_SMS_LENGTH) {
		_sms_text_len = MAX_SMS_LENGTH;
	}
	_sms_text = malloc(_sms_text_len + 1);
	snprintf(_sms_text, _sms_text_len + 1, "%s", asms);

	DEBUGLOG(printf("%s - %s\n", _receiver_number, _sms_text));
	//计算要发送几次
	smscount=CalcSMSSendCount(_sms_text);
	if (smscount==0) {
		result = -1;
		goto __EXIT__;
	};
	phonecount=SplitePhoneNumber(_receiver_number);
	callback_step=80/(smscount*phonecount);

	DEBUGLOG(printf("%d numbers, sms length %d\n", phonecount, smscount));
	fd=OpenConn(callback);
	if (callback) {
		callback(20);
	}
	if (fd ==-1) {
		DEBUGLOG(printf("initconn error!\n"));
		result = -1;
		goto __EXIT__;
	}

	encodingSMSC(getSMSCNumber(fd), esmsc);
	if (code) {
		//FIXME NOT thread safe!
		strcpy(code, getCountryCode());
	}

	DEBUGLOG(printf("encodingSMSC() success\n"));
	for (j=0; j<phonecount; j++) {
		encodingPhone(j, ephone);
		DEBUGLOG(printf("encodingPhone() success\n"));
		//分多次发送
		for (i=0; i<smscount; i++) {
			encodingSMS(i, esms,smscount,i+1);
			pdu=encodingPDU(esmsc, ephone, esms,smscount,i+1);
			callback_count=20+(i+j+1)*callback_step;
			callback(callback_count);
			atcmd=encodingATCMD(pdu);
			if (!sendsms(fd, atcmd, pdu)) {
				DEBUGLOG(printf("sendsms() failed\n"));
				result = -1;
				goto __EXIT__;
			}
		}
		DEBUGLOG(printf("sendsms() done\n"));
	}
	if (callback) {
		callback(100);
	}	
	DEBUGLOG(printf("Send Success! result : %d\n", result));

	__EXIT__:
	DEBUGLOG(printf("sendmessage() Cleaning up\n"));
	// Clean up and exit
	free(_receiver_number);
	_receiver_number = 0;
	free(_sms_text);
	_sms_text = 0;
	FreePhoneBuf();
	if (fd) {
		CloseConn(fd);
		fd = -1;
	}
	return result;
}
