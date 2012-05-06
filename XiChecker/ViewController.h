//
//  ViewController.h
//  XiChecker
//
//  Copyright (c) 2012 Takuya Kawasaki.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
	BOOL m_tryLogin;
}
@property (retain, nonatomic) IBOutlet UILabel *data1;
@property (retain, nonatomic) IBOutlet UILabel *data2;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *busyIcon;
- (IBAction)updateData:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
