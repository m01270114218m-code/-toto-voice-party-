import 'package:flutter_test/flutter_test.dart';
import 'package:mt2_voice_party/main.dart';
import 'package:mt2_voice_party/screens/myninja_design_screen.dart';

void main() {
  testWidgets('MT2 app starts with the embedded design screen', (tester) async {
    await tester.pumpWidget(const Mt2App());
    expect(find.byType(Mt2DesignScreen), findsOneWidget);
  });
}
