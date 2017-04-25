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

#ifndef encodeh
#define encodeh

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

char * encodingSMSC(char *smsc,char *encodedsmsc);

char * encodingPhone(int index,char *encodedphone);

int  CalcSMSSendCount(char *sms);
						
char *encodingSMS(int index,char *encodedSMS,int msgCount,int msgIdx);

char *encodingPDU(char *encodedsmsc,char * encodedphone,char *encodedsms,int msgCount,int msgIdx);

char *encodingATCMD(char *pdu);
int  SplitePhoneNumber(char *phone);
char *getCountryCode();

void FreePhoneBuf();

//only for debug
/*char * CalcCountryCode(char *smsc);
char * ProcessPhoneNumberWithCountryCode(char *buf);
char * getCountryCode();
char * setCountryCode(char *);
char *getUSMS();*/
#ifdef __cplusplus
}
#endif
#endif


