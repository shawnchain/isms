#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include "unicode_helper.h"

//#define DEBUG_ENABLED 1

char *InvertString(char *invertStr) {
	int Len;
	int i;
	char t;

	Len=strlen(invertStr);

	if (Len%2) {
		sprintf(invertStr, "%sF", invertStr);
		Len++;
	}

	for (i=0; i<Len; i+=2) {
		t=invertStr[i];
		invertStr[i]=invertStr[i+1];
		invertStr[i+1]=t;
	}

	return invertStr;
}

char gUnicodeSMS[65535], gPDU[65535], atcmd[128], tPDU[65535];
char *phonebuf[1000], phonecount=0;
char gCode[4];
int p_len;
Boolean isChinaUser, isInternationNumber;

void getcode(char *phone, char *retcode) {
	char buf[128];
	char code[4];
	memset(code, 0, 4);
	strcpy(buf, phone);

	char *p=buf;
	switch (*p) {
	case '1':
		strcpy(code, "1");
		break;
	case '2':
		p++;
		switch (*p) {
		case '0':
			strcpy(code, "20");
			break;
		case '7':
			strcpy(code, "27");
			break;
		default:
			p+=2;
			*p=0;
			strcpy(code, buf);
		}
		break;
	case '3':
		p++;
		switch (*p) {
		case '5':
		case '7':
		case '8':
			p+=2;
			*p=0;
			strcpy(code, buf);
			break;
		default:
			*++p=0;
			strcpy(code, buf);
		}
		break;
	case '4':
		p++;
		if (*p=='2') {
			p+=2;
			*p=0;
			strcpy(code, buf);
		} else {
			*++p=0;
			strcpy(code, buf);
		}
		;
		break;

	case '5':
		p++;
		if (*p=='9') {
			p+=2;
			*p=0;
			strcpy(code, buf);
		} else {
			*++p=0;
			strcpy(code, buf);
		}
		;

		break;

	case '6':
		p++;
		switch (*p) {
		case '7':
		case '8':
		case '9':
			p+=2;
			*p=0;
			strcpy(code, buf);
			break;
		default:
			*++p=0;
			strcpy(code, buf);
			break;
		}
		break;

	case '7':

		strcpy(code, "7");
		break;
	case '8':
		p++;
		switch (*p) {
		case '1':
		case '2':
		case '4':
		case '6':
			*++p=0;
			strcpy(code, buf);
			break;
		default:
			p+=2;
			*p=0;
			strcpy(code, buf);
			break;
		}
		break;

	case '9':
		p++;
		switch (*p) {
		case '6':
		case '7':
		case '9':
			p+=2;
			*p=0;
			strcpy(code, buf);
			break;
		default:
			*++p=0;
			strcpy(code, buf);
			break;
		}
		break;
	default:
		break;

	}
	strcpy(retcode, code);
}

char * encodingSMSC(char *smsc, char *encodedsmsc) {
	char buf[128], buf2[128];

	/*短信中心号码*/
	//1、将短信息中心号码去掉+号，看看长度是否为偶数，如果不是，最后添加F 
	//	即 addr = "+8613800200500" 
	//  => addr = "8613800200500F" 
	//2、将奇数位和偶数位交换。 
	//  => addr = "683108020005F0" 
	//3、将短信息中心号码前面加上字符91，91是国际化的意思 
	//  => addr = "91683108020005F0" 
	//4、算出 addr 长度，结果除2，格式化成2位的16进制字符串，16 / 2 = 8 => "08" 
	//=> addr = "0891683108020005F0" 
	char *p;
	if (strlen(smsc)>0) {
		p=smsc;
		if (*p=='+')
			p++;
		strcpy(buf2, p);
		if ((buf2[0]=='8') && (buf2[1]=='6'))
			isChinaUser=true;
		else
			isChinaUser=false;
	}
	getcode(p, gCode);
	sprintf(buf, "91%s", InvertString(buf2));
	sprintf(encodedsmsc, "%02X%s", (unsigned int)(strlen(buf)/2), buf);
}

char * ProcessPhoneNumberWithCountryCode(char *buf) {
	//目前实现的功能是 如果是中国大陆的用户，检查是不是“86”开头的，如果是，删除86

	char tbuf[128];

	char *p=buf;
	//memset(tbuf,0,128);
	if (isChinaUser && (!isInternationNumber)) {
		if ((*p=='8') && (*(p+1)=='6')) {
			strcpy(tbuf, p+2);
			strcpy(buf, tbuf);
		}
	}
	return buf;
}

int SplitePhoneNumber(char *phone) {
	int i, count=0;
	char *p, *prev, *pstring;
	char buf[4096];

	memset(phonebuf, 0, sizeof(phonebuf));
	strcpy(buf, phone);
	p=buf;
	prev=buf;

	for (i=0; i<=strlen(phone); i++) {

		if ((*p==',')||(*p==0)) {
			pstring=(char *)malloc(p-prev+1);
			*p=(char)0;
			strcpy(pstring, prev);
			prev=p+1;
			phonebuf[count]=pstring;
			count++;
		}
		p++;
	}

	return count;
}

void FreePhoneBuf() {
	int i;
	for (i=0; i<phonecount; i++) {
		free(phonebuf[i]);
	}
}

char * encodingPhone(int index, char *encodedphone) {
	char buf[128], *pp, *pb, *phone;
	int i, len;
	/*对方手机号码*/
	//1、将手机号码去掉+号，看看长度是否为偶数，如果不是，最后添加F 
	//即 phone = "+8613602433649" 
	//=> phone = "8613602433649F" 
	//2、将手机号码奇数位和偶数位交换。 
	//=> phone = "683106423346F9" 

	phone=phonebuf[index];
	pp=phone;
	pb=buf;
	len = strlen(phone);
	if (len>128)
		return NULL;
	memset(buf, 0, sizeof(buf));
	//查查看是不是国际电话号码
	if (*pp=='+')
		isInternationNumber=true;
	else
		isInternationNumber=false;

	//去除非数字，比如电话号码里有空格或者‘-’之类的 包括开头的那个+
	for (i=0; i<len; i++) {
		if ((*pp>='0') && (*pp<='9'))
			*pb++=*pp;
		*pp++;
	}
	//如果是国内的用户，手机号码包含86，删除之
	ProcessPhoneNumberWithCountryCode(buf);
	p_len=strlen(buf);
	sprintf(encodedphone, "%s", InvertString(buf));
}

int CalcSMSSendCount(char *sms) {

	memset(gUnicodeSMS, 0, sizeof(gUnicodeSMS));
	utf8_to_utf16(sms, gUnicodeSMS);
	// 短信的最大长度是70个字符,每个字符被格式化成4个字节
	return (int)strlen(gUnicodeSMS)/(70*4)+1;
}

/**
 * Enhanced by Shawn to support large text
 */
char *encodingSMS(int index, char *encodedSMS,int msgCount,int msgIdx) {
	char *pStart;
	char buf[70*4+1];
	memset(buf, 0, sizeof(buf));
	/*短信内容*/
	// 1、转字符串转换为Unicode代码，例如“工作愉快！”的unicode代码为 5DE54F5C61095FEBFF01， 
	// msg 长度除2，保留两位16进制数，即 5DE54F5C61095FEBFF01 = 20 / 2 => "0A"，再加上 msg 
	// msg = "0A5DE54F5C61095FEBFF01" 
	
	if(msgCount > 1){
		// need 12 bytes for the header
		pStart=gUnicodeSMS+index*(70*4 - 12);
		memcpy(buf, pStart, 70*4 - 12);
		// Add the header
		/*
05  - 协议头的长度 
00  - 标志这是个分拆短信 
03  - 分拆数据元素的长度 
39  - 唯一标志（用于把两条短信合并） 
02  - 一共两条 
01  - 这是第一条
		 */
		unsigned int msgLen = (unsigned int)((12/*header*/ + strlen(buf))/2)/*msg length*/;
#ifdef DEBUG_ENABLED
		printf("packet length %d\n",msgLen);
#endif		
		sprintf(encodedSMS,"%02X05000339%02X%02X%s",msgLen, msgCount,msgIdx,buf);
	}else{
		pStart=gUnicodeSMS+index*70*4;
		memcpy(buf, pStart, 70*4);
		sprintf(encodedSMS, "%02X%s", (unsigned int)(strlen(buf)/2), buf);	
	}
	return encodedSMS;
}

char *encodingPDU(char *encodedsmsc, char * encodedphone, char *encodedsms, int msgCount, int msgIdx) {

	memset(gPDU, 0, sizeof(gPDU));

	//手机号码前加上字符串 xx 00 0D 91（xx:通常为11,如果msgCount > 1则为51. 00：固定，0D：手机号码的长度，不算＋号，十六进制表示，91：发送到国际为91，发送到国内为81）
	// 即 phone = "11000D91" + phone 
	//=> 11000D91683106423346F9
	//2、手机号码后加上 000800 和刚才的短信息内容，000800也写死就可以了 
	// Shawn Note: here 00 08 00 means:
	//   00:协议标识 (TP-PID), 是普通 GSM 类型，点到点方式
	//   08:用户信息编码方式 (TP-DCS) , 7-bit 编码（ 08 ： UCS2 编码） 
	//   00:有效期 (TP-VP), 短信的有效时间 
	//3. 紧接着短信息长度 

	//4. 添加报头，如果是多个短信息的话。
	
	//5. 内容
	
	//6. ctrl+z and cr
	//即 phone = phone + "000800" + msg 
	//即 11000D91683106423346F9 + 000800 + 0A5DE54F5C61095FEBFF01 
	//=> phone = 11000D91683106423346F90008000A5DE54F5C61095FEBFF01 
	//3、phone 长度除以2，格式化成2位的十进制数
	// 即 11000D91683106423346F90008000A5DE54F5C61095FEBFF01 => 50位 / 2 => 25 
	//最后面加ctrl+z和回车
	char* __buf = (char*)gPDU;
	if(msgCount > 1){
		__buf[0] = '5';
		__buf[1] = '1';
	}else{
		//TODO 处理需要feedback的情况，第5bit=1
		if(false/*need feedback*/){
			__buf[0] = '3';
			__buf[1] = '1';			
		}else{
			__buf[0] = '1';
			__buf[1] = '1';
		}
	}
	__buf+=2; // Move 2 bytes forward for next contents
	
	// Now finish the left part
	if (isInternationNumber){
		sprintf(__buf, "00%02X91%s000800%s%c%c", p_len, encodedphone,
				encodedsms, 26, 13);
	}else{
		sprintf(__buf, "00%02X81%s000800%s%c%c", p_len, encodedphone,
				encodedsms, 26, 13);
	}
	
	
	/*发送短信命令*/
	//发送短信的命令"AT+CMGS=(短信长度/2)回车"
	//gPDU的长度是去掉ctrl+z和回车的长度
	sprintf(atcmd, "AT+CMGS=%ld\r", (strlen(gPDU)-2)/2);

	//把短信中心号码也加在短信内容上
	sprintf(tPDU, "%s%s", encodedsmsc, gPDU);
	strcpy(gPDU, tPDU);

	/*send message*/
	/*
	 所以要发送的内容为 
	 AT+CMGF=0 <回车> 
	 OK 
	 AT+CMGS=25<回车> 
	 > addr+phone <Ctrl+Z发送> 
	 */
	return gPDU;
}

char *getCountryCode() {
	return gCode;
}
char *encodingATCMD(char *pdu) {
	return atcmd;
}

