#import <UIKit/UIKit.h>
#include "ABSRootListController.h"

@implementation ABSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AutoBatterySaverPrefs" target:self] retain];
	}

	return _specifiers;
}

- (void)respring {
	system("killall -9 SpringBoard");
}

- (void)openTwitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/i4M1k0SU"]];
}

@end
