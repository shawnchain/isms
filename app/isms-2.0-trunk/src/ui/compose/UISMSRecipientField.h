#ifndef UISMSRECIPIENTFIELD_H_
#define UISMSRECIPIENTFIELD_H_

#import "Prefix.h"
#import <UIKit/UITextField.h>

#define UI_RECEIPT_FIELD_HEIGHT 43.0f
#define UI_RECEIPT_FIELD_WIDTH 280.0f

/***************************************************************
 * Extend to the UITextField to handle extra events,
 * support multipal recipients
 * 
 * @Author Shawn
 ***************************************************************/
@interface UISMSRecipientField : UITextField{
	BOOL textChanged;
	NSMutableDictionary *recipients;
}

/**
 * Get recipient map, key is the number, value is the name
 */
- (NSDictionary*)recipients;

/**
 * Clear recipients
 */
- (void)clearRecipients;

/**
 * Add recipient to existing rcpt list
 */
- (void)addRecipient:(NSString*) name withNumber:(NSString*)number;
- (void)addRecipient:(NSString*) name withNumber:(NSString*)number shouldNotifyChange:(BOOL)shouldNotifyChange;

-(NSString*)rcipientNumberForName:(NSString*)name;

@end
#endif /*UISMSRECIPIENTFIELD_H_*/
