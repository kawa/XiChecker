//
//  LoginViewController.m
//  XiChecker
//
//  Copyright (c) 2012 Takuya Kawasaki.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textBoxId;
@synthesize textBoxPassword;
@synthesize busyIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults objectForKey:@"CurrentUserName"];
	[textBoxId setText:username];
	NSString *password = [userDefaults objectForKey:@"CurrentPassword"];
	[textBoxPassword setText:password];
	[textBoxId becomeFirstResponder];
}

- (void)viewDidUnload
{
	[self setBusyIcon:nil];
	[self setTextBoxId:nil];
	[self setTextBoxPassword:nil];
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[busyIcon release];
	[textBoxId release];
	[textBoxPassword release];
	[super dealloc];
}

- (IBAction)dismissLogin:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [textBoxId text];
	[userDefaults setObject:username forKey:@"CurrentUserName"];	
	NSString *password = [textBoxPassword text];
	[userDefaults setObject:password forKey:@"CurrentPassword"];	
	[[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end
