// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';
import '../tests/bloc_tests/note_bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'note_bloc_test.mocks.dart'; 

// Generate a mock class for NoteBloc
@GenerateMocks([NoteBloc])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockNoteBloc = MockNoteBloc();
    // Build our app and trigger a frame.
     await tester.pumpWidget(
    MyApp(noteBloc: mockNoteBloc), // Pass the mock noteBloc
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
