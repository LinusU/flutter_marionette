import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class MarionetteDisposedError extends Error {
  MarionetteDisposedError();
  String toString() => "This Marionette instance have been disposed";
}

class Marionette {
  static const MethodChannel _channel = const MethodChannel('flutter_marionette');

  final Future<String> _idFuture;
  bool _disposed = false;

  Marionette(): _idFuture = _channel.invokeMethod('init');

  void dispose() {
    _disposed = true;

    _idFuture.then((id) {
      _channel.invokeMethod('dispose', <String, dynamic>{ 'id': id });
    });
  }

  Future<void> click(String selector) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('click', <String, dynamic>{
      'id': await _idFuture,
      'selector': selector,
    });
  }

  Future<dynamic> evaluate(String script) async {
    if (_disposed) throw MarionetteDisposedError();

    return jsonDecode(await _channel.invokeMethod('evaluate', <String, dynamic>{
      'id': await _idFuture,
      'script': script,
    }));
  }

  Future<void> goto(String url) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('goto', <String, dynamic>{
      'id': await _idFuture,
      'url': url,
    });
  }

  Future<void> setContent(String html) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('setContent', <String, dynamic>{
      'id': await _idFuture,
      'html': html,
    });
  }

  Future<void> type(String selector, String text) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('type', <String, dynamic>{
      'id': await _idFuture,
      'selector': selector,
      'text': text,
    });
  }

  Future<void> reload() async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('reload', <String, dynamic>{
      'id': await _idFuture,
    });
  }

  Future<void> waitForFunction(String fn) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('waitForFunction', <String, dynamic>{
      'id': await _idFuture,
      'fn': fn,
    });
  }

  Future<void> waitForNavigation() async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('waitForNavigation', <String, dynamic>{
      'id': await _idFuture,
    });
  }

  Future<void> waitForSelector(String selector) async {
    if (_disposed) throw MarionetteDisposedError();

    await _channel.invokeMethod('waitForSelector', <String, dynamic>{
      'id': await _idFuture,
      'selector': selector,
    });
  }
}
