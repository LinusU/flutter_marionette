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
