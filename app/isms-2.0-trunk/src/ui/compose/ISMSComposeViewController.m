//==============================================================================
//	Created on 2008-09-13
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2007,2008>  Shawn Qian(shawn.chain@gmail.com)
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

#import "ISMSComposeViewController.h"
#import "ObjectContainer.h"
#import "UIController.h"

@implementation ISMSComposeViewController

//@synthesize composeArea;
//@synthesize recipientView;
@synthesize recipientField;
@synthesize textView;
@synthesize sendButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = NSLocalizedStringFromTable(@"New Message",@"iSMS",@"");
		UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel",@"iSMS",@"") style:UIBarButtonItemStylePlain
																	 target:self action:@selector(onCancel)];
//		UINavigationItem *it = self.navigationItem;
//		[it setRightBarButtonItem:(id)cancelBtn];
		[[self navigationItem] setRightBarButtonItem:cancelBtn];
		[cancelBtn release];
	}
	return self;
}

- (void)loadView {
	self.view = [[ObjectContainer sharedInstance] getObjectForKey:@"UIComposeSMSView"];
}


- (void)viewWillAppear:(BOOL)animated {
	[self.view willShow:nil];
	//[self.recipientField setEditable:YES];
	//[self.recipientField becomeFirstResponder];
}

/*
- (void)viewDidLoad {
	[composeArea setBottomBufferHeight:0.0f];
	[composeArea setAllowsRubberBanding:YES];
	[composeArea setAdjustForContentSizeChange:YES];	
}
*/


/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}

- (IBAction)onCancel {
	[self.view onCancel];
	//[[UIController defaultController] switchBackFrom:self.view];
	//	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSend {

}

- (IBAction)onChooseSmiley{
/*
	ISMSSmileyChooseViewController *c = [[ISMSSmileyChooseViewController alloc] initWithNibName:@"SmileyChooseView" bundle:nil];
	UINavigationController *nav = [self navigationController];
	assert(nav != nil);
	[nav presentModalViewController:c animated:YES];
//	[self presentModalViewController:c animated:YES];
	//[c release];
*/
}

+(id) sharedInstance{
	static id instance = nil;
	if(instance == nil){
		instance = [[self alloc] initWithNibName:@"ComposeView" bundle:nil];
	}
	return instance;
}

-(void)_updateButtonState{
	[sendButton setEnabled:([recipientField.text length] != 0 && [textView.text length] == 0)];
}

- (IBAction)onRecipientChanged {
    [self _updateButtonState];
}

- (IBAction)onTextChanged {
	[self _updateButtonState];
}
@end
