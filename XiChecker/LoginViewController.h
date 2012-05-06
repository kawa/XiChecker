//
//  LoginViewController.h
//  XiChecker
//
//  Copyright (c) 2012 Takuya Kawasaki.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *busyIcon;
- (IBAction)dismissLogin:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *textBoxId;
@property (retain, nonatomic) IBOutlet UITextField *textBoxPassword;

@end
