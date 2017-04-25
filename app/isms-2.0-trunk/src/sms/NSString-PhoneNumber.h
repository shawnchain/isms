#ifndef NSSTRINGPHONENUMBER_H_
#define NSSTRINGPHONENUMBER_H_

#import <Foundation/Foundation.h>

NSString* _formalizePhoneNumber(NSString*);

@interface NSString(PhoneNumber)
-(NSString*)formalizedPhoneNumber;
@end


#endif /*NSSTRINGPHONENUMBER_H_*/
