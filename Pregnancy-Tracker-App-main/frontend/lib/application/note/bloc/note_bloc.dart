import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend/domain/note/note.dart';

import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepositoryInterface noteRepositoryInterface;

  NoteBloc({required this.noteRepositoryInterface})
      : super(const NoteStateInitial()) {
  on<NoteEventAdd>((event, emit) async {
  emit(const NoteStateLoading());

  Either<NoteFailure, NoteDomain> result =
      await noteRepositoryInterface.addNote(event.noteForm);

  print('Result bloc is $result');

  await result.fold(
    (failure) async {
      print('Failed to add note: $failure');
      emit(NoteStateFailure(failure));
    },
    (note) async {
      print('Fetching updated notes after adding a new note...');
      
      // Fetch updated notes
      Either<NoteFailure, List<NoteDomain>> fetchResult =
          await noteRepositoryInterface.getNotesForUser(note.author);

      await fetchResult.fold(
        (failure) async {
          print('Failed to fetch updated notes: $failure');
          emit(NoteStateFailure(failure));
        },
        (notes) async {
          print('Updated notes fetched successfully.');
          emit(NoteStateSuccessMultiple(notes));
        },
      );
    },
  );
});



    on<NoteEventUpdate>((event, emit) async {
      emit(const NoteStateLoading());

      Either<NoteFailure, NoteDomain> result = await noteRepositoryInterface
          .updateNote(noteForm: event.noteForm, noteId: event.noteId);

      print('update result is $result');
      result.fold(
          (l) => emit(NoteStateFailure(l)), (r) => emit(NoteStateSuccess(r)));
    });

    on<NoteEventDelete>((event, emit) async {
      emit(const NoteStateLoading());

      Either<NoteFailure, Unit> result =
          await noteRepositoryInterface.deleteNote(event.noteId);

      result.fold(
          (l) => emit(NoteStateFailure(l)), (r) => emit(NoteStateDeleted()));
    });

    on<NoteEventGetByUser>((event, emit) async {
      emit(const NoteStateLoading());

      Either<NoteFailure, List<NoteDomain>> result =
          await noteRepositoryInterface.getNotesForUser(event.userId);
      print(result);
      result.fold((l) => emit(NoteStateFailure(l)),
          (r) => emit(NoteStateSuccessMultiple(r)));
    });
  }
}
