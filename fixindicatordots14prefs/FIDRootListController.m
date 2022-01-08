#import <Foundation/Foundation.h>
#import "FIDRootListController.h"

@implementation FIDRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)_returnKeyPressed:(id)arg1 {
    [self.view endEditing:YES];
}

@end
