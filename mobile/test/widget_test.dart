import 'package:flutter_test/flutter_test.dart';
import 'package:mt2_voice_party/main.dart';

void main() {
  testWidgets('MT2 app starts on the home screen', (tester) async {
    await tester.pumpWidget(const Mt2App());
    expect(find.text('MT2 PARTY'), findsOneWidget);
    expect(find.text('Popular Rooms'), findsOneWidget);
  });
}
