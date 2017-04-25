//
//  BalloonCell.h
//  MobileChatApp
//
//  Created by Shaun Harrison on 9/1/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIView.h>
#import <UIKit/UI9PartImageView.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIBox.h>



@interface BalloonCell : UITableCell {
	UITextView	*text;
	float		height;
}
-(id)initWithText:(NSString*)text direction:(BOOL)direction;
- (void) setText: (NSString*)message send: (BOOL)send;
//- (float) createSendBubbleWithRect: (CGRect) rect;
//- (float) createRecvBubbleWithRect: (CGRect) rect;
- (float) height;
+ (CGSize) textSizeWithWidth:(float)width text:(NSString*)text;
+(CGSize) textSizeWithLineLength:(int)maxLineLen text:(NSString*)text;

-(UIView*)_createBubbleViewWithRect:(CGRect)rect outgoing:(BOOL)outgoing;
//- (BOOL)showSelection;
//- (void)setSelected:(BOOL)flag;
//- (BOOL)isSelected;
//- (void)updateHighlightColors;
//- (void)setSelected:(BOOL)fp8 withFade:(BOOL)fp12;
@end

@interface BalloonCellBack : UIView {
	int _style;
}

- (id) initWithFrame: (CGRect) rect style: (int) style;
- (void) drawRect: (CGRect) rect;
@end
