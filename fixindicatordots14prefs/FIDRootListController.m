#import <Foundation/Foundation.h>
#import "FIDRootListController.h"

@interface NSTask : NSObject
-(void)setLaunchPath:(id)arg1;
-(void)setArguments:(id)arg1;
-(void)launch;
@end

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

- (void)respring:(id)sender {
    NSTask *respring = [[NSTask alloc] init];
    [respring setLaunchPath:@"/usr/bin/killall"];
    [respring setArguments:[NSArray arrayWithObjects:@"-9", @"SpringBoard", nil]];
    [respring launch];
}

@end
