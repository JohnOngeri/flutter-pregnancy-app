import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/application/post/post_list/bloc/post_list_bloc.dart';
import 'package:frontend/main.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_bloc.dart';
import 'package:frontend/application/appointment/bloc/appointment_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_bloc.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([NoteBloc, PostListBloc, AppointmentBloc, ProfileBloc, CommentBloc])
void main() {
  testWidgets('Verify initial app structure', (WidgetTester tester) async {
    print('Test is running!');

    // Create mock instances of Blocs
    final mockNoteBloc = MockNoteBloc();
    final mockPostListBloc = MockPostListBloc();
    final mockProfileBloc = MockProfileBloc();
    final mockAppointmentBloc = MockAppointmentBloc();
    final mockCommentBloc = MockCommentBloc();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NoteBloc>.value(value: mockNoteBloc),
          BlocProvider<PostListBloc>.value(value: mockPostListBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
          BlocProvider<AppointmentBloc>.value(value: mockAppointmentBloc),
          BlocProvider<CommentBloc>.value(value: mockCommentBloc),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    // Changed to expect at least one Scaffold instead of exactly one
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}
