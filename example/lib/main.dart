import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_marionette/marionette.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '...';

  @override
  void initState() {
    super.initState();
    this.evaluate();
  }

  Future<void> evaluate() async {
    final page = Marionette();
    final result = await page.evaluate("'Hello, World!'");
    setState(() { _result = result; });
    page.dispose();
  }

  Future<void> scrape() async {
    setState(() { _result = "init"; });
    final page = Marionette();

    setState(() { _result = "goto"; });
    await page.goto("https://example.com/");

    setState(() { _result = "evaluate"; });
    final result = await page.evaluate("document.querySelector('h1').textContent");

    setState(() { _result = result; });
    page.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$_result\n'),
              RaisedButton(
                child: Text('test'),
                onPressed: () { this.scrape(); },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
