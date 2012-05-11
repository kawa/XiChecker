//
//  ViewController.h
//  XiChecker
//
//  Copyright (c) 2012 Takuya Kawasaki.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
	BOOL m_tryLogin;
	NSInteger m_maxKBperMonth;
	NSInteger m_maxKBperDays;
}
@property (retain, nonatomic) IBOutlet UILabel *data1;
@property (retain, nonatomic) IBOutlet UILabel *data2;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *busyIcon;
- (IBAction)updateData:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *labelMaxPerMonth;
@property (retain, nonatomic) IBOutlet UILabel *labelMaxPerDays;
@property (retain, nonatomic) IBOutlet UIProgressView *meter1;
@property (retain, nonatomic) IBOutlet UIProgressView *meter2;

@end
