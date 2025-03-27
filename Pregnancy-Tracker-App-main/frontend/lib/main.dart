import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/firebase_options.dart';

// Application layer
import 'package:frontend/application/appointment/bloc/appointment_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_bloc.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'package:frontend/application/page_provider/bloc/page_provider_bloc.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_bloc.dart';
import 'package:frontend/application/tip/bloc/tip_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_bloc.dart';
import 'package:frontend/application/prediction_bloc.dart';

// Domain interfaces
import 'package:frontend/domain/note/note_repository_interface.dart';
import 'package:frontend/domain/comment/comment_repository_interface.dart';
import 'package:frontend/domain/profile/profile_repository_interface.dart';
import 'package:frontend/domain/appointment/appointment_repository_interface.dart';
import 'package:frontend/domain/tip/tip_repository_interface.dart';
import 'package:frontend/domain/post/post_repository_interface.dart';
import 'package:frontend/domain/prediction_repository.dart';

// Infrastructure
import 'package:frontend/infrastructure/note/note_api.dart';
import 'package:frontend/infrastructure/note/note_repository.dart';
import 'package:frontend/infrastructure/comment/comment_api.dart';
import 'package:frontend/infrastructure/comment/comment_repository.dart';
import 'package:frontend/infrastructure/profile/profile_api.dart';
import 'package:frontend/infrastructure/profile/profile_repository.dart';
import 'package:frontend/infrastructure/appointment/appointment_api.dart';
import 'package:frontend/infrastructure/appointment/appointment_repository.dart';
import 'package:frontend/infrastructure/tip/tip_api.dart';
import 'package:frontend/infrastructure/tip/tip_repository.dart';
import 'package:frontend/infrastructure/post/post_api.dart';
import 'package:frontend/infrastructure/post/post_repository.dart';
import 'package:frontend/infrastructure/prediction_service.dart';
import 'package:frontend/domain/prediction_repository_impl.dart';
// main.dart
import 'package:frontend/infrastructure/profile/profile_api.dart';

// ...
// Presentation
import 'package:frontend/presentation/core/Themes/light_theme.dart';
import 'package:frontend/presentation/routes/routes.dart';

void main() async {
  // Initialize SQLite FFI
  sqfliteFfiInit();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (error) {
    debugPrint('Error initializing Firebase: $error');
    rethrow;
  }

  // Initialize API clients
  final noteApi = NoteAPI();
  final postApi = PostAPI();
  final commentApi = CommentAPI();
  final profileApi = ProfileApi();
  final appointmentApi = AppointmentAPI();
  final tipApi = TipAPI();
  final predictionService = PredictionService();

  // Initialize repositories with their dependencies
  final NoteRepositoryInterface noteRepository = NoteRepository(noteApi);
  final PostRepositoryInterface postRepository = PostRepository(postApi);
  final CommentRepositoryInterface commentRepository = CommentRepository(commentApi);
  final ProfileRepositoryInterface profileRepository = ProfileRepository(profileApi);
  final AppointmentRepositoryInterface appointmentRepository = AppointmentRepository(appointmentApi);
  final TipRepositoryInterface tipRepository = TipRepository(tipApi);
  final PredictionRepository predictionRepository = PredictionRepositoryImpl(predictionService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NoteBloc(noteRepositoryInterface: noteRepository)),
        BlocProvider(create: (_) => PostListBloc(postRepository: postRepository)),
        BlocProvider(create: (_) => AppointmentBloc(appointmentRepositoryInterface: appointmentRepository)),
        BlocProvider(create: (_) => TipBloc(tipRepositoryInterface: tipRepository)),
        BlocProvider(create: (_) => CommentBloc(commentRepositoryInterface: commentRepository)),
        BlocProvider(create: (_) => ProfileBloc(profileRepositoryInterface: profileRepository)),
        BlocProvider(create: (_) => PredictionBloc(predictionRepository as PredictionRepositoryImpl)),
        BlocProvider(create: (_) => PageProviderBloc()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'Pregnancy Tracker',
    theme: LightTheme().getThemeData,
    routerConfig: router,
    builder: (context, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(  // Ensure Scaffold wraps everything
          body: Material( // Ensure Material is present for InkWell and other widgets
            child: child ?? SizedBox(), // Prevent null child issues
          ),
        ),
      );
    },
  );
}
}