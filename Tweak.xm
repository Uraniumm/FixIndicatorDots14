#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
BOOL dpkgInvalid = NO;

double xoffset; 
double yoffset;
double xsize;
double ysize;
double shittyTempVar;
BOOL tweakEnabled;
HBPreferences *preferences;

#pragma mark TWEAK_GROUP_STARTS
%group tweak

%hook SBRecordingIndicatorWindow

-(void)setFrame:(CGRect)arg1 {
    arg1 = CGRectMake(xoffset, yoffset, xsize, ysize);
    return %orig(arg1);
}
%end

%hook SBRecordingIndicatorViewController

-(void)_configureRootLayer {
    %orig;
    shittyTempVar = 0 - xoffset;
    CALayer* rootLayer = MSHookIvar<CALayer*>(self, "_rootLayer");
    rootLayer.bounds = CGRectMake(shittyTempVar, yoffset, xsize, ysize);
}
%end

%end
%ctor {
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.fixindicatordots14.list"];
  if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.fixindicatordots14.md5sums"];

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.fixindicatordots14"];
  [preferences registerDefaults:@ { //defaults for prefernces
		@"tweakEnabled" : @YES,
		@"xoffset" : @"20",
		@"yoffset" : @"0",
		@"xsize" : @"414",
		@"ysize" : @"896",
	}];
	[preferences registerDouble:&xoffset default:20 forKey:@"xoffset"];
	[preferences registerDouble:&yoffset default:0 forKey:@"yoffset"];
	[preferences registerDouble:&xsize default:414 forKey:@"xsize"];
	[preferences registerDouble:&ysize default:896 forKey:@"ysize"];
	[preferences registerBool:&tweakEnabled default:YES forKey:@"tweakEnabled"];
	if (tweakEnabled && !dpkgInvalid) {
		%init(tweak);
	}
}
