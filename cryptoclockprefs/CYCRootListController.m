#import <Foundation/Foundation.h>
#import "CYCRootListController.h"
#import "spawn.h"

@implementation CYCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)_returnKeyPressed:(id)arg1 {
    [self.view endEditing:YES];
}

- (void)loadView {
    [super loadView];
    ((UITableView *)[self table]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)respring:(id)sender {
        pid_t pid;
        const char *args[] = {"sbreload", NULL, NULL, NULL};
        posix_spawn(&pid, "usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
}

@end
