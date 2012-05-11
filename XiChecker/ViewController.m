//
//  ViewController.m
//  XiChecker
//
//  Copyright (c) 2012 Takuya Kawasaki.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize statusLabel;
@synthesize labelMaxPerMonth;
@synthesize labelMaxPerDays;
@synthesize data1;
@synthesize data2;
@synthesize busyIcon;

#define OFFLINE_DEBUG (1)

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	m_tryLogin = NO;
	m_maxKBperMonth = 7340032;
	m_maxKBperDays = 1048576;
	[self loadAllData];
}

- (void)viewDidUnload
{
	[self setData1:nil];
	[self setData2:nil];
	[self setBusyIcon:nil];
	[self setStatusLabel:nil];
	[self setLabelMaxPerMonth:nil];
	[self setLabelMaxPerDays:nil];
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
	[data1 release];
	[data2 release];
	[busyIcon release];
	[statusLabel release];
	[labelMaxPerMonth release];
	[labelMaxPerDays release];
	[super dealloc];
}

- (NSInteger)dataStrToInt:(NSString *)dataStr {
//	NSError *error = nil;
//	NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
	NSString *targetStr = [dataStr stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSInteger result = [targetStr intValue];
	return result;
}

- (void)updateDate {
	NSDate *now = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[statusLabel setText:[NSString stringWithFormat:@"%@ 更新",[formatter stringFromDate:now]]];
}

- (void)saveAllData {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[data1 text] forKey:@"UserData1"];	
	[ud setObject:[data2 text] forKey:@"UserData2"];	
	[ud setObject:[statusLabel text] forKey:@"UserStatusLabel"];		
}

- (void)loadAllData {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSMutableString *data1Str = [ud objectForKey:@"UserData1"];
	if (![data1Str length]) {
		[data1Str setString:@"0KB"];
	}
	[data1 setText:data1Str];
	NSMutableString *data2Str = [ud objectForKey:@"UserData2"];
	if (![data2Str length]) {
		[data2Str setString:@"0KB"];
	}
	[data2 setText:data2Str];
	NSMutableString *statusLabelStr = [ud objectForKey:@"UserStatusLabel"];
	if (![statusLabelStr length]) {
		[statusLabelStr setString:@"ログインしていません"];
	}
	[statusLabel setText:statusLabelStr];
}

- (void)updateTask {
	BOOL failed = NO;
	{
#if OFFLINE_DEBUG
		NSString *receivedStr = [NSString stringWithString:@"1,234,567KB"];
//		NSString *receivedStr = [NSString stringWithString:@"dummy"];
#else
		NSMutableData *receivedData = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.mydocomo.com/dcm/dfw/bis/guide/charges/gkyap001.srv?Xitraffic=1"]];
		NSString *receivedStr = [[NSString alloc] initWithData:receivedData encoding:NSShiftJISStringEncoding];
#endif
		NSError *error = nil;
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([,0-9]+KB)" options:0 error:&error];
		if (error != nil) {
			NSLog(@"[ERROR] %@", error);
		} else {
			NSTextCheckingResult *match = [regexp firstMatchInString:receivedStr options:0 range:NSMakeRange(0, receivedStr.length)];
			if ([match numberOfRanges] < 2) {
				failed = YES;
			} else {
				NSString *dataStr = [receivedStr substringWithRange:[match rangeAtIndex:0]];
				NSInteger dataInt = [self dataStrToInt:dataStr];
				NSInteger percentOfUse = dataInt * 100 / m_maxKBperMonth;
				NSLog(@"[Days] %d%%", percentOfUse);
				[data1 setText:dataStr];
			}
		}
	}
	if (!failed) {
#if OFFLINE_DEBUG
		NSString *receivedStr = [NSString stringWithString:@"123,456KB"];
#else
		NSMutableData *receivedData = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.mydocomo.com/dcm/dfw/bis/guide/charges/gkyap001.srv"]];
		NSString *receivedStr = [[NSString alloc] initWithData:receivedData encoding:NSShiftJISStringEncoding];
#endif
		NSError *error = nil;
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([,0-9]+KB)" options:0 error:&error];
		if (error != nil) {
			NSLog(@"[ERROR] %@", error);
		} else {
			NSTextCheckingResult *match = [regexp firstMatchInString:receivedStr options:0 range:NSMakeRange(0, receivedStr.length)];
			if ([match numberOfRanges] < 2) {
				failed = YES;
			} else {
				NSString *dataStr = [receivedStr substringWithRange:[match rangeAtIndex:0]];
				NSInteger dataInt = [self dataStrToInt:dataStr];
				NSInteger percentOfUse = dataInt * 100 / m_maxKBperDays;
				NSLog(@"[Days] %d%%", percentOfUse);
				[data2 setText:dataStr];
			}
		}
	}
	[busyIcon stopAnimating];
	if (failed) {
		if (m_tryLogin) {
			m_tryLogin = NO;
			[self login];
		} else {
			[statusLabel setText:@"ログインしていません"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ログインに失敗しました" message:@"IDまたはパスワードに誤りがあります。ログイン設定で正しいIDとパスワードを設定してください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
		}
	} else {
//		[statusLabel setText:@""];
		[self updateDate];
		[self saveAllData];
	}
}

- (IBAction)updateData:(id)sender {
	m_tryLogin = YES;
	[busyIcon startAnimating];
	[statusLabel setText:@"データを更新しています"];
	[NSThread detachNewThreadSelector:@selector(updateTask) toTarget:self withObject:nil];
}

- (void)login {
	[busyIcon startAnimating];
	[statusLabel setText:@"ログインしています"];
	[NSThread detachNewThreadSelector:@selector(loginTask) toTarget:self withObject:nil];
}

- (void)loginTask
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [userDefaults objectForKey:@"CurrentUserName"];
	NSString *password = [userDefaults objectForKey:@"CurrentPassword"];

	NSString *bodyString = [NSString stringWithFormat:@"MDCM_UID=%@&MDCM_PWD=%@&HIDEURL=%3FMDCM_AK%3Dhttps%253a%252f%252fwww.mydocomo.com%252fdcm%252fdfw%252fag%26path%3D%252fdcm%252fdfw%252fweb%252fportal%252fpub2%252fMYDPS-TR0001.do%26query%3D&LOGIN=MDCM_LOGIN&MDCM_KEY=0&MDCM_SAVE=0", username, password];
	NSData *httpBody = [bodyString dataUsingEncoding:NSShiftJISStringEncoding];
	
	NSURL *url = [NSURL URLWithString:@"https://www.mydocomo.com/dcm/dfw"];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[req setHTTPMethod:@"POST"];
	[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[req setValue:[NSString stringWithFormat:@"%d", [httpBody length]] forHTTPHeaderField:@"Content-Length"];
	[req setHTTPBody:httpBody];
	[req setHTTPShouldHandleCookies:YES];
	
	NSURLResponse* response;
	NSError *error = nil;
	[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
	if(error) {
		NSLog(@"[ERROR] %@", error);
	}
	[statusLabel setText:@"データを更新しています"];
	[self updateTask];
}

@end
