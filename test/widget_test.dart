import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voca/main.dart';

void main() {
  testWidgets('App renders feed screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VocaApp()));
    await tester.pumpAndSettle();

    expect(find.text('Voca'), findsOneWidget);
  });
}
