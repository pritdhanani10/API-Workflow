import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('API Workflow App loads title cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const ApiWorkflowApp());

    expect(find.text('🚀 API Workflow Architecture'), findsOneWidget);
  });
}
