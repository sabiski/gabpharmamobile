import 'package:flutter_test/flutter_test.dart';
import 'package:gabpharmamobile/main.dart';
import 'package:get/get.dart';

void main() {
  testWidgets("Gab'Pharma se construit", (tester) async {
    await tester.pumpWidget(const GabPharmaApp());
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
