// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/main.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_bloc.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_bloc.dart';
import 'package:frontend/application/appointment/bloc/appointment_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_bloc.dart';
import 'widget_test.mocks.dart';

@GenerateMocks(
    [NoteBloc, PostListBloc, AppointmentBloc, ProfileBloc, CommentBloc])
void main() {
  testWidgets('Verify initial app structure', (WidgetTester tester) async {
    print('Test is running!');

    final mockNoteBloc = MockNoteBloc();
    final mockPostlistBloc = MockPostListBloc();
    final mockProfileBloc = MockProfileBloc();
    final mockAppointmentBloc = MockAppointmentBloc();
    final mockCommentBloc = MockCommentBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(
          noteBloc: mockNoteBloc,
          postListBloc: mockPostlistBloc,
          profileBloc: mockProfileBloc,
          appointmentBloc: mockAppointmentBloc,
          commentBloc: mockCommentBloc,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}

MyApp(
    {required MockNoteBloc noteBloc,
    required MockPostListBloc postListBloc,
    required MockProfileBloc profileBloc,
    required MockAppointmentBloc appointmentBloc,
    required MockCommentBloc commentBloc}) {}
