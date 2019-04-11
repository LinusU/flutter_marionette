# Marionette for Flutter

Marionette is a library which provides a high-level API to control a WebView.

The goal is to have the API closely mirror that of Puppeteer.

Other platforms: [Swift (macOS/iOS)](https://github.com/LinusU/Marionette), [JavaScript (Node)](https://github.com/LinusU/marionettejs)

## Usage

```dart
import 'package:flutter_marionette/marionette.dart';

() async {
  final page = Marionette();

  await page.goto("https://www.google.com/");
  await page.type("input[name='q']", "LinusU Marionette")
  await Future.wait([page.waitForNavigation(), page.click("input[type='submit']")]);

  page.dispose();
}
```

## iOS

To be able to use Marionette on iOS, you need to give Marionette a hook to your view hierarchy. Otherwise the `WKWebView` will get suspended by the OS, and your Promises will never settle.

This is accomplished by using the `setGlobalUIHook` function before instantiating any `Marionette` instances.

**Flutter:**

If you have a non-modified Flutter application, this should be added to `ios/Runner/AppDelegate.swift`, in the `application(_:didFinishLaunchingWithOptions:)` function.

```diff
--- a/ios/Runner/AppDelegate.swift
+++ b/ios/Runner/AppDelegate.swift
@@ -1,5 +1,6 @@
 import UIKit
 import Flutter
+import flutter_marionette

 @UIApplicationMain
 @objc class AppDelegate: FlutterAppDelegate {
   override func application(
     _ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
   ) -> Bool {
+    SwiftFlutterMarionettePlugin.setGlobalUIHook(window: UIApplication.shared.windows.first!)
     GeneratedPluginRegistrant.register(with: self)
     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
   }
```

**App:**

```swift
// Can be called from anywhere, e.g. your AppDelegate
SwiftFlutterMarionettePlugin.setGlobalUIHook(window: UIApplication.shared.windows.first!)
```

**App Extension:**

```swift
// From within your root view controller
SwiftFlutterMarionettePlugin.setGlobalUIHook(viewController: self)
```
