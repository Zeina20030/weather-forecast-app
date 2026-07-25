import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_forecast_app/main.dart';

void main() {
  testWidgets('App renders the home screen without crashing', (WidgetTester tester) async {
    dotenv.testLoad(fileInput: 'OPENWEATHER_API_KEY=test_key');

    await tester.pumpWidget(const WeatherApp());
    await tester.pump();

    expect(find.text('Weather'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
