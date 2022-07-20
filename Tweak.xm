#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>


//	=========================== Preference vars ===========================

static BOOL enabled;
static long fontSize1;
static BOOL bold1;
static long fontSize2;
static BOOL bold2;
static NSString *locale;
static NSString *token;
static NSString *base;
static double timeout;
static long alignment;
static BOOL hideLocationIndicator;
static BOOL disableBreadcrumbs;

//	============================= Other vars =============================

static UIFont *font1;
static UIFont *font2;
static NSDateFormatter *formatter1;
static NSMutableAttributedString *finalString;
static HBPreferences *pref;
static NSString *format1;
static NSString *price;

//	========================== Network Helper ===========================

@interface NetworkHelper : NSObject
-(void)getPriceData;
-(NSString *)formatPrice:(NSString *)arg1;
@end

@implementation NetworkHelper
-(void)getPriceData {
  // NSLog(@"CryptoClock: INFO: in getPriceData.");
  // static NSString *priceData;
  NSString *baseURL = [NSString stringWithFormat:@"https://min-api.cryptocompare.com/data/price?fsym=%@&tsyms=%@", token, base];
  NSURL *url = [NSURL URLWithString:baseURL];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if ( !error ) {
        NSString *newPrice = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        // NSLog(@"CryptoClock: DEBUG: completionHandler:newPrice = %@", newPrice);
        if ( !(newPrice == (id)[NSNull null] || newPrice.length == 0 ) ) {
          price = [self formatPrice:newPrice];
        }
        // NSLog(@"CryptoClock: DEBUG: completionHandler:priceData = %@", price);
        // NSLog(@"CryptoClock: DEBUG: completionHandler:error = %@", error);
      }
      else {
        NSLog(@"CryptoClock: DEBUG: completionHandler:error = %@", error);
      }
  }];

  [task resume];
}

-(NSString *)formatPrice:(NSString *)arg1 {
  // NSLog(@"CryptoClock: INFO: in formatPrice.");
  NSRange r1 = [arg1 rangeOfString:@":"];
  NSRange r2 = [arg1 rangeOfString:@"}"];
  NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
  NSString *priceString = [arg1 substringWithRange:rSub];

  return priceString;
}
@end

//	======================== Classes / Functions ========================

@interface _UIStatusBarStringView : UILabel
@property(nullable, nonatomic, copy) NSString *text;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSInteger numberOfLines;
@property(nullable, nonatomic, copy) NSAttributedString *attributedText;
@end

//	=============================== Hooks ===============================

%group label // 1
%hook _UIStatusBarStringView // 2

- (void)applyStyleAttributes: (id)arg1
{
  // NSLog(@"CryptoClock: INFO: in applyStyleAttributes.");
	if(!(self.text != nil && [self.text containsString: @":"])) %orig;
}

-(void)setText: (NSString*)text
{
  // NetworkHelper *netHelp = [[NetworkHelper alloc] init];
  // [NSTimer scheduledTimerWithTimeInterval:10.0f target:netHelp selector:@selector(testFunction) userInfo:nil repeats:YES];
  // NSLog(@"CryptoClock: INFO: in setText.");
  // price = [NetworkHelper getPriceData];
  if( [text containsString: @":"] && !(price == (id)[NSNull null] || price.length == 0 ) ) {
    if ([price containsString:@"Error"]) {
      return %orig;
    }
    else {
      @autoreleasepool {
        NSDate *nowDate = [NSDate date];

        [finalString setAttributedString: [[NSAttributedString alloc] initWithString: [formatter1 stringFromDate: nowDate] attributes: @{ NSFontAttributeName: font1 }]];
        [finalString appendAttributedString: [[NSAttributedString alloc] initWithString:price attributes: @{ NSFontAttributeName: font2 }]];
        // NSLog(@"CryptoClock: INFO: in setText:mutator");
        self.textAlignment = alignment;
        self.numberOfLines = 2;
        [self setAdjustsFontSizeToFitWidth: YES];
        self.attributedText = finalString;
      }	
    }
  }
  else {
    return %orig;
  }
}
%end // 2
%end // 1

%group disableBreadcrumbsGroup
%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

+ (BOOL)_shouldAddBreadcrumbToActivatingSceneEntity: (id)arg1 sceneHandle: (id)arg2 withTransitionContext: (id)arg3
{
  // NSLog(@"CryptoClock: INFO: in _shouldAddBreadcrumbToActivatingSceneEntity.");
  return NO;
}
%end
%end

%group hideLocationIndicatorGroup // 1
%hook _UIStatusBarIndicatorLocationItem // 2

- (id)applyUpdate: (id)arg1 toDisplayItem: (id)arg2 {
  // NSLog(@"CryptoClock: INFO: in applyUpdate.");
  return nil;
}
%end // 2
%end // 1

%ctor {
  @autoreleasepool {
    pref = [[HBPreferences alloc] initWithIdentifier: @"com.cryptoclockprefs"];
    [pref registerDefaults:
      @{
      @"enabled": @NO,
      @"format1": @"h:mm",
      @"fontSize1": @14,
      @"bold1": @YES,
      @"fontSize2": @10,
      @"bold2": @NO,
      @"locale": @"en_US",
      @"token": @"ETH",
      @"base": @"USD",
      @"alignment": @1,
      @"timeout": @"60.0",
      @"hideLocationIndicator": @NO,
      @"disableBreadcrumbs": @NO
    }];

    enabled = [pref boolForKey: @"enabled"];
    if(enabled) {
      format1 = [pref objectForKey: @"format1"];
      fontSize1 = [pref integerForKey: @"fontSize1"];
      bold1 = [pref boolForKey: @"bold1"];
      fontSize2 = [pref integerForKey: @"fontSize2"];
      bold2 = [pref boolForKey: @"bold2"];
      locale = [pref objectForKey: @"locale"];
      token = [pref objectForKey: @"token"];
      base = [pref objectForKey: @"base"];
      alignment = [pref integerForKey: @"alignment"];
      timeout = [pref doubleForKey: @"timeout"];
      hideLocationIndicator = [pref boolForKey: @"hideLocationIndicator"];
      disableBreadcrumbs = [pref boolForKey: @"disableBreadcrumbs"];
      formatter1 = [[NSDateFormatter alloc] init];
      formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
      formatter1.timeStyle = NSDateFormatterNoStyle;
      formatter1.dateFormat = [NSString stringWithFormat:@"%@\n", format1];
      if(bold1) font1 = [UIFont boldSystemFontOfSize: fontSize1];
      else font1 = [UIFont systemFontOfSize: fontSize1];
      if(bold2) font2 = [UIFont boldSystemFontOfSize: fontSize2];
      else font2 = [UIFont systemFontOfSize: fontSize2];
      finalString = [[NSMutableAttributedString alloc] init];
      NetworkHelper *netHelp = [[NetworkHelper alloc] init];
      [netHelp getPriceData];
      [NSTimer scheduledTimerWithTimeInterval:timeout target:netHelp selector:@selector(getPriceData) userInfo:nil repeats:YES];
      %init(label);
      if(disableBreadcrumbs) %init(disableBreadcrumbsGroup);
      if(hideLocationIndicator) %init(hideLocationIndicatorGroup);
    }
  }
}
