# GSConfiguration

[![CI Status](http://img.shields.io/travis/gliders/GSConfiguration.svg?style=flat)](https://travis-ci.org/gliders/GSConfiguration)
[![Version](https://img.shields.io/cocoapods/v/GSConfiguration.svg?style=flat)](http://cocoadocs.org/docsets/GSConfiguration)
[![License](https://img.shields.io/cocoapods/l/GSConfiguration.svg?style=flat)](http://cocoadocs.org/docsets/GSConfiguration)
[![Platform](https://img.shields.io/cocoapods/p/GSConfiguration.svg?style=flat)](http://cocoadocs.org/docsets/GSConfiguration)

## What Is It?

GSConfiguration is a type-safe, generalized configuration library for iOS applications. It supports multiple local
plist config files as well as remote JSON configuration services. All configuration files are
represented by classes with @dynamic properties similar to Core Data's NSManagedObject.

## Installation

GSConfiguration is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "GSConfiguration"

## Basic Usage

The first step to use GSConfiguration is to define a plist somewhere in your app with some differently typed values. 
Let's call it "Config.plist"

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>coolFeatureActivated</key>
    <true/>
    <key>timeout</key>
    <real>60</real>
    <key>serviceName</key>
    <string>some service</string>
    <key>totallyAwesomeUrl</key>
    <string>https://github.com/gliders/GSConfiguration</string>
    <key>cachePolicy</key>
    <real>1</real>
</dict>
</plist>
```

Then create a subclass of GSConfiguration and define @dynamic properties just like you would if you were creating an 
NSManagedObject entity.
 
```objective-c
@interface ApplicationConfig : GSConfiguration

@property BOOL coolFeatureActivated;
@property NSTimeInterval timeout;
@property NSString *serviceName;
@property NSURL *totallyAwesomeUrl; // Note: This is an NSURL here but String in the plist.
@property NSURLRequestCachePolicy cachePolicy;

@end

@implementation ApplicationConfig

@dynamic coolFeatureActivated;
@dynamic timeout;
@dynamic apiKey;
@dynamic totallyAwesomeUrl;
@dynamic cachePolicy;

@end
```

Next, configure GSConfiguration to load your plist and store the data somewhere. This is usually done before the first 
time you need to use a configuration value, probably in your AppDelegate.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GSConfigurationManager setStore:[GSUserDefaultsStore store]];
    [GSConfigurationManager addSource:[GSDictionarySource sourceWithPListNamed:@"Config"]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [GSConfigurationManager cleanUp]; // This will synchronize NSUserDefaults store.
}
```

That's it! Now, whenever you need a configuration value just interact with the ApplicationConfig facade and use it like 
a normal object.

```objective-c
ApplicationConfig *config = [ApplicationConfig config];

if (config.coolFeatureActivated) {
    [self doCoolFeatureWithServiceNamed:config.serviceName];
}

NSURLRequest *request = [NSURLRequest requestWithURL:config.totallyAwesomeUrl // automatic type conversion here
                                         cachePolicy:config.cachePolicy
                                     timeoutInterval:config.timeout];
```

## I Want To Use A Custom Type

Of course you do. By default, any object that implements NSCoding should encode and decode just fine. Don't want to mess 
with NSCoding? Define an NSValueTransformer and register it with GSConfigurationManager. Make sure it can take a 
string and reverse the transformation back into a string. Check out GSURLStringTransformer for inspiration and consider 
using TransformerKit.

```objective-c
[NSValueTransformer setValueTransformer:[[GSURLStringTransformer alloc] init]
                                        forName:GSURLStringTransformerName];

[GSConfigurationManager registerTransformerName:GSURLStringTransformerName forClass:[NSURL class]];
```

## I Want To Control Configurations Remotely

Sometimes we need to control our apps from afar. I've got you covered. Add a GSRemoteSource and pass an NSURL that points 
to a JSON service with additional configuration values. You can even tell the source to poll continuously on an interval. 
  
```objective-c
GSRemoteSource *remote = [GSRemoteSource sourceWithEndpoint:[NSURL URLWithString:@"http://example.com/api/config"] 
                                                parserBlock:^NSDictionary *(id jsonData) {
    // If your JSON is complex or not simply a dictionary with key/values, 
    // parse it as needed and return a dictionary of just key/values.
    return jsonData;
}];
remote.refreshIntervalInSeconds = 300;
[GSConfigurationManager addSource:remote];
```

## We Need To Go Deeper

Not enough? That's cool. You can also define multiple facades to organize your configurations as needed. Want a different 
configuration for Release and Debug? Just add the release configuration after the debug configuration in release mode. 
Debug values for keys with matching names will be automatically squashed.

## Gotchas

 * All GSConfiguration subclass property names are shared in a single 
dictionary. This means if you define two properties in two GSConfiguration subclasses with the same exact name they will 
map to the same value internally. 

 * The order in which you add sources matters. The last source added wins when they contain different values for the same key.
 
## Logging

Turn on logging by defining a macro:

```objective-c
#define GS_CONFIG_LOGGING_ENABLED 1
```

If CocoaLumberjack is present, GSConfiguration will automatically use that instead. 

## Future Plans

 * Facade Key-Value Observing support
 * Secure keychain storage via a GSSecureConfiguration facade for more sensitive configuration data. 

## Author

[Ryan Brignoni](https://github.com/castral)  
Twitter: [@RyanBrignoni](https://twitter.com/RyanBrignoni)

## License

GSConfiguration is available under the MIT license. See the LICENSE file for more info.

