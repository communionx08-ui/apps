import 'package:swift_core/swift_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_rider/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SwiftRiderApp());
  });
}
