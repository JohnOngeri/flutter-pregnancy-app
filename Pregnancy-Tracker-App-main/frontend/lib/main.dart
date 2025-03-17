import 'package:dartz/dartz_streaming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/appointment/bloc/appointment_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_bloc.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'package:frontend/application/page_provider/bloc/page_provider_bloc.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_bloc.dart';
import 'package:frontend/application/tip/bloc/tip_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_bloc.dart';
import 'package:frontend/application/prediction_bloc.dart';// Import PredictionsBloc
import 'package:frontend/infrastructure/comment/comment_api.dart';
import 'package:frontend/infrastructure/comment/comment_repository.dart';
import 'package:frontend/infrastructure/note/note_api.dart';
import 'package:frontend/infrastructure/note/note_repository.dart';
import 'package:frontend/infrastructure/post/post_api.dart';
import 'package:frontend/infrastructure/post/post_repository.dart';
import 'package:frontend/infrastructure/prediction_service.dart'; // Import PredictionsAPI
import 'package:frontend/domain/prediction_repository.dart'; // Import PredictionsRepository
import 'package:frontend/presentation/core/Themes/light_theme.dart';
import 'package:frontend/presentation/landingpage/landing_page.dart';
import 'package:frontend/presentation/login/login_page.dart';
import 'package:frontend/presentation/posts/posts_page.dart';
import 'package:frontend/infrastructure/profile/profile_repository.dart';
import 'package:frontend/presentation/BabyStatus/baby_status_page.dart';
import 'package:frontend/presentation/appointments/appointment_page.dart';
import 'package:frontend/presentation/appointments/components/add_appointmentpage.dart';
import 'package:frontend/presentation/notes/symptoms/notes_page.dart';
import 'package:frontend/presentation/profile/components/editprofile.dart';
import 'package:frontend/presentation/profile/profile.dart';
import 'package:frontend/presentation/signup/signup_page.dart';
import 'package:frontend/presentation/tips/home_page.dart';
import 'package:go_router/go_router.dart';
import 'infrastructure/appointment/appointment_api.dart';
import 'infrastructure/appointment/appointment_repository.dart';
import 'infrastructure/profile/profile_api.dart';
import 'infrastructure/tip/tip_api.dart';
import 'infrastructure/tip/tip_repository.dart';
import 'presentation/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/firebase_options.dart';
import '../domain/prediction_repository_impl.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print('Firebase initialized successfully');
  }).catchError((error) {
    print('Error initializing Firebase: $error');
  });

  // Initialize repositories and blocs
  NoteAPI noteApi = NoteAPI();
  NoteRepository noteRepository = NoteRepository(noteApi);
  NoteBloc noteBloc = NoteBloc(noteRepositoryInterface: noteRepository);

  PostAPI postApi = PostAPI();
  PostRepository postRepository = PostRepository(postApi);
  PostListBloc postBloc = PostListBloc(postRepository: postRepository);

  CommentAPI commentAPI = CommentAPI();
  CommentRepository commentRepository = CommentRepository(commentAPI);
  CommentBloc commentBloc = CommentBloc(commentRepositoryInterface: commentRepository);

  ProfileApi profileApi = ProfileApi();
  ProfileRepository profileRepository = ProfileRepository(profileApi);
  ProfileBloc profileBloc = ProfileBloc(profileRepositoryInterface: profileRepository);

  AppointmentAPI appointmentApi = AppointmentAPI();
  AppointmentRepository appointmentRepository = AppointmentRepository(appointmentApi);
  AppointmentBloc appointmentBloc = AppointmentBloc(appointmentRepositoryInterface: appointmentRepository);

  TipAPI tipApi = TipAPI();
  TipRepository tipRepository = TipRepository(tipApi);
  TipBloc tipBloc = TipBloc(tipRepositoryInterface: tipRepository);

  // Initialize PredictionsBloc
  PredictionService predictionService = PredictionService();
  PredictionRepository predictionsRepository = PredictionRepositoryImpl(predictionService);
  PredictionBloc predictionBloc = PredictionBloc(predictionsRepository as PredictionRepositoryImpl);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>.value(value: noteBloc),
        BlocProvider<PostListBloc>.value(value: postBloc),
        BlocProvider<AppointmentBloc>.value(value: appointmentBloc),
        BlocProvider<TipBloc>.value(value: tipBloc),
        BlocProvider<CommentBloc>.value(value: commentBloc),
        BlocProvider<ProfileBloc>.value(value: profileBloc),
        BlocProvider<PredictionBloc>.value(value: predictionBloc), // Add PredictionsBloc
      ],
      child: MyApp(
        noteBloc: noteBloc,
        appointmentBloc: appointmentBloc,
        postBloc: postBloc,
        commentBloc: commentBloc,
        profileBloc: profileBloc,
        predictionsBloc: predictionBloc, // Pass PredictionsBloc to MyApp
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final NoteBloc noteBloc;
  final PostListBloc postBloc;
  final AppointmentBloc appointmentBloc;
  final CommentBloc commentBloc;
  final ProfileBloc profileBloc;
  final PredictionBloc predictionsBloc; // Add PredictionsBloc

  const MyApp({
    Key? key,
    required this.noteBloc,
    required this.postBloc,
    required this.appointmentBloc,
    required this.profileBloc,
    required this.commentBloc,
    required this.predictionsBloc, // Add PredictionsBloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Timeline Demo',
      theme: LightTheme().getThemeData,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NoteBloc>.value(value: noteBloc),
          BlocProvider<PostListBloc>.value(value: postBloc),
          BlocProvider<CommentBloc>.value(value: commentBloc),
          BlocProvider<ProfileBloc>.value(value: profileBloc),
          BlocProvider<PageProviderBloc>.value(value: PageProviderBloc()),
          BlocProvider<PredictionBloc>.value(value: predictionsBloc), // Add PredictionsBloc
        ],  
        child: Scaffold(
          body: MaterialApp.router(
            theme: LightTheme().getThemeData,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}