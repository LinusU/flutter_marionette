import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_marionette/marionette.dart';

void main() {
  test('Smoke test', () async {
    final page = Marionette();
    await page.goto("https://example.com/");

    final result = await page.evaluate("document.querySelector('h1').textContent");
    expect(result, 'Example Domain');
  });
}
