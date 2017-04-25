/*
 * Unicode Helper
 * Author: 	
 *		mjevans 
 *		gaoxiaojun 
 * Version: 	1.0
 * Date:	2007-10-2
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ConvertUTF.h"


void char2buf(char *sBuf,char *dBuf);
UTF16 * UTF8toUTF16(char * s, int * count);


char * utf8_to_utf16(char *s,char *d)
{
char *inBuf;
UTF16 *ret=NULL;
int i,count;
unsigned char c1,c2;

unsigned char *p=NULL,*psmsBuffer=NULL;
char tBuf[3];

//char2buf(s,inBuf);
inBuf=s;

ret= UTF8toUTF16(inBuf,&count);
if (0!=count){
	psmsBuffer=(unsigned char *)d;
	p=psmsBuffer;
        for (i=0;i<count-1;i++){
                        c1=*(ret+i)>>8;
                        c2=*(ret+i);
			sprintf(tBuf,"%.2X",c1);
			*psmsBuffer=tBuf[0];*psmsBuffer++;
			*psmsBuffer=tBuf[1];*psmsBuffer++;
			 sprintf(tBuf,"%.2X",c2);
                        *psmsBuffer=tBuf[0];*psmsBuffer++;
                        *psmsBuffer=tBuf[1];*psmsBuffer++;
                }
	*psmsBuffer=0x0;
	}
free (ret);
return (char *) p;
}

void char2buf(char *sBuf,char *dBuf)
{
int i;
char buf[3]={0x1,0x2,0x0};
char *p,*pend;
p=sBuf;
int len=strlen(sBuf)/2;
for (i=0;i<len;i++){
        buf[0]=*p;p++;
        buf[1]=*p;p++;
        dBuf[i]=strtol(buf,&pend,16);
        }
dBuf[len]=0x0;
}


/*
 * Detect UTF8String Encoding Length and Count needed Bytes;
 */
int UTF8StringCount(char * pUTF8EncodingString)
{
	ConversionResult ErrorCode;
	unsigned int bytes;
        int slen;
        UTF8 *source_start, *source_end;

        slen = strlen(pUTF8EncodingString);
        source_start = (UTF8 *)pUTF8EncodingString;
        source_end = (UTF8 *)(pUTF8EncodingString + slen + 1);              /* include NUL terminator */


	if (NULL != pUTF8EncodingString) {
		 ErrorCode = ConvertUTF8toUTF16 ((const UTF8 **)&source_start,source_end,NULL,NULL,strictConversion,&bytes);		
		 if (ErrorCode == conversionOK) 
			return bytes;
	}
	return 0;
}


/*
 * Get a UTF16 * representation of a UTF8 format char *
 * The representation is a converted copy, so the result needs to be freed
 * char * s == NULL is handled properly
 * count*sizeof(UTF16) is bytes count for result;
 * Does not handle byte arrays, only null-terminated strings.
 */

UTF16 * UTF8toUTF16(char * s, int * count)
{
    UTF16 * buf=NULL;

    if (NULL!=s) {
        unsigned int widechrs,bytes; 
        int slen;
        ConversionResult ret;
        UTF8 *source_start, *source_end;
        UTF16 *target_start, *target_end;

        slen = strlen(s);

        bytes = UTF8StringCount(s);
        widechrs = bytes / sizeof(UTF16);
	*count = widechrs;
        
	buf=(UTF16 *)malloc((widechrs+1)*sizeof(UTF16));
	memset(buf,0,(widechrs+1)*sizeof(UTF16));

        if (widechrs != 0) {
            source_start = (UTF8 *)s;
            source_end = (UTF8 *)(s + slen + 1);              /* include NUL terminator */
	    target_start = (UTF16 *)buf;
            target_end = (UTF16 *)(buf + widechrs + 1);

            
            ret = ConvertUTF8toUTF16(
                (const UTF8 **)&source_start, source_end,
                &target_start, target_end, strictConversion, &bytes);
            if (ret != conversionOK) {
                printf("UNICODE_ERROR: second call to ConvertUTF8toUTF16 failed (%d)", ret);
            }
        }
    }
    return buf;
}



