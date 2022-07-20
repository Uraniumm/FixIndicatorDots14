#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
BOOL dpkgInvalid = NO;

double xoffset; 
double yoffset;
double size;
BOOL tweakEnabled;
HBPreferences *preferences;

@interface SBRecordingIndicatorViewController : UIViewController
-(void)calculateInitialIndicatorPositionAndSize;
-(void)setActiveInterfaceOrientation:(long long)arg1;
@end

#pragma mark TWEAK_GROUP_STARTS
%group tweak

%hook SBRecordingIndicatorViewController

-(void)calculateInitialIndicatorPositionAndSize {
    %orig;
    MSHookIvar<CGFloat>(self, "_sideOffset") += xoffset;
    MSHookIvar<CGFloat>(self, "_topOffset") += yoffset;
    MSHookIvar<CGFloat>(self, "_size") += size;
    [self setActiveInterfaceOrientation:0];
}
%end

%end
%ctor {
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.fixindicatordots14.list"];
	if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.fixindicatordots14.md5sums"];

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.fixindicatordots14"];
	[preferences registerDefaults:@ {
		@"tweakEnabled" : @YES,
		@"xoffset" : @"0",
		@"yoffset" : @"0",
		@"size" : @"0",
	}];

	[preferences registerDouble:&xoffset default:0 forKey:@"xoffset"];
	[preferences registerDouble:&yoffset default:0 forKey:@"yoffset"];
	[preferences registerDouble:&size default:0 forKey:@"size"];
	[preferences registerBool:&tweakEnabled default:YES forKey:@"tweakEnabled"];

	if (tweakEnabled && !dpkgInvalid) {
		%init(tweak);
	}
}
