import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt2_voice_party/main.dart';

void main() {
  test('MT2 app exposes a Flutter application root', () {
    const app = Mt2App();
    expect(app, isA<StatelessWidget>());
  });
}
