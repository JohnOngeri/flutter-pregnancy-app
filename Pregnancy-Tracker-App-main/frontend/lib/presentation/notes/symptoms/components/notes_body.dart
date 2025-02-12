import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/note/bloc/note_event.dart';
import 'package:frontend/application/note/bloc/note_bloc.dart';
import 'package:frontend/application/note/bloc/note_state.dart';
import 'package:frontend/presentation/notes/symptoms/components/add_notepage.dart';
import 'package:frontend/presentation/notes/symptoms/components/note_item.dart';

import '../../../../local_data/shared_preferences/jj_shared_preferences_service.dart';
import '../../../core/constants/assets.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);

  @override
  _NoteBodyState createState() => _NoteBodyState();
}

class _NoteBodyState extends State<NoteBody> {
  @override
  Widget build(BuildContext context) {
    print("NoteBody build called");
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              Assets.assetsImagesEllipse55,
              scale: 5,
            ),
          ),
          // Plus button and background
          const Body(),
          const PlusButton(),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late NoteBloc noteBloc;
  var notes = [];
  final SharedPreferenceService service = SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    print("Initializing BodyState");
    noteBloc = BlocProvider.of<NoteBloc>(context);

    service.getProfileId().then((value) {
      if (value != null) {
        print("Fetched profile ID: $value");
        fetchNotes(value);
      } else {
        print("Error: Profile ID is null");
      }
    }).catchError((error) {
      print("Error fetching profile ID: $error");
    });
  }

  Future<void> fetchNotes(String userId) async {
    print("Dispatching NoteEventGetByUser for user ID: $userId");
    noteBloc.add(NoteEventGetByUser(userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteStateFailure) {
          print("NoteStateFailure: Failed to fetch notes");
        }
      },
      bloc: noteBloc,
      builder: (context, state) {
        print("Current state: $state");

        if (state is NoteStateLoading) {
          print("Loading notes...");
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NoteStateSuccessMultiple) {
          print("Notes fetched successfully: ${state.notes.length} notes");
          notes = state.notes.reversed.toList();
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              var item = NoteItem(
                title: note.title,
                body: note.body,
                NoteId: note.id,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: item,
              );
            },
          );
        } else if (state is NoteStateFailure) {
          return Center(
            child: Text("Failed to fetch notes:}"),
          );
        } else {
          return const Center(
            child: Text("No notes found"),
          );
        }
      },
    );
  }
}

class PlusButton extends StatelessWidget {
  const PlusButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotePage(),
              ));
        },
        child: Stack(
          children: [
            Image.asset(
              Assets.assetsImagesEllipse8,
              scale: 3.8,
            ),
            const Positioned(
              top: 20,
              left: 20,
              child: Center(child: Icon(size: 40, Icons.edit)),
            ),
          ],
        ),
      ),
    );
  }
}
