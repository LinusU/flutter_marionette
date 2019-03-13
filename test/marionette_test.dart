import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_marionette/marionette.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_marionette');
  final calls = List<String>();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      calls.add(methodCall.toString());
      return '"foobar"';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('evaluate', () async {
    final page = Marionette();
    final result = await page.evaluate('"foobar"');

    expect(calls[0], 'MethodCall(init, null)');
    expect(calls[1], 'MethodCall(evaluate, {id: "foobar", script: "foobar"})');
    expect(result, 'foobar');
  });
}
