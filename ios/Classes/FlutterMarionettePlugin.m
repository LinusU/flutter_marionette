#import "FlutterMarionettePlugin.h"
#import <flutter_marionette/flutter_marionette-Swift.h>

@implementation FlutterMarionettePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMarionettePlugin registerWithRegistrar:registrar];
}
@end
