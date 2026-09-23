import 'package:flutter_test/flutter_test.dart';
import 'package:voice_room_royal/main.dart';

void main() {
  testWidgets('Royal Voice starts', (tester) async {
    await tester.pumpWidget(const RoyalVoiceApp());
    expect(find.text('الغرف المباشرة'), findsOneWidget);
  });
}
