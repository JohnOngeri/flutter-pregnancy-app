import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend/domain/comment/comment.dart';

import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepositoryInterface commentRepositoryInterface;

  CommentBloc({required this.commentRepositoryInterface})
      : super(const CommentStateInitial()) {
    on<CommentEventGetComments>((event, emit) async {
      print('CommentBloc: Handling CommentEventGetComments');
      emit(const CommentStateLoading());

      Either<CommentFailure, List<CommentDomain>> result =
          await commentRepositoryInterface.getComments();

      result.fold(
        (l) {
          print('CommentBloc: Failed to get comments - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully fetched comments - ${r.length} comments found');
          emit(CommentStateSuccessMultiple(r));
        },
      );
    });

    on<CommentEventGetCommentsForPost>((event, emit) async {
      print('CommentBloc: Handling CommentEventGetCommentsForPost - postId: ${event.postId}');
      emit(const CommentStateLoading());

      Either<CommentFailure, List<CommentDomain>> result =
          await commentRepositoryInterface.getCommentsForPost(event.postId);

      result.fold(
        (l) {
          print('CommentBloc: Failed to get comments for post - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully fetched comments for post - ${r.length} comments found');
          emit(CommentStateSuccessMultiple(r));
        },
      );
    });

    on<CommentEventGetUserComments>((event, emit) async {
      print('CommentBloc: Handling CommentEventGetUserComments - userid: ${event.userid}');
      emit(const CommentStateLoading());

      Either<CommentFailure, List<CommentDomain>> result =
          await commentRepositoryInterface.getUserComments(event.userid);

      result.fold(
        (l) {
          print('CommentBloc: Failed to get user comments - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully fetched user comments - ${r.length} comments found');
          emit(CommentStateSuccessMultiple(r));
        },
      );
    });

    on<CommentEventAddComment>((event, emit) async {
      print('CommentBloc: Handling CommentEventAddComment - commentForm: ${event.commentForm}');
      emit(const CommentStateLoading());

      Either<CommentFailure, CommentDomain> result =
          await commentRepositoryInterface.addComment(event.commentForm);

      result.fold(
        (l) {
          print('CommentBloc: Failed to add comment - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully added comment - commentId: ${r.id}');
          emit(CommentStateSuccess(r));
        },
      );
    });

    on<CommentEventUpdateComment>((event, emit) async {
      print('CommentBloc: Handling CommentEventUpdateComment - commentForm: ${event.commentForm}, commentId: ${event.commentId}');
      emit(const CommentStateLoading());

      Either<CommentFailure, CommentDomain> result =
          await commentRepositoryInterface.updateComment(commentForm: event.commentForm, commentId: event.commentId);

      result.fold(
        (l) {
          print('CommentBloc: Failed to update comment - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully updated comment - commentId: ${r.id}');
          emit(CommentStateSuccess(r));
        },
      );
    });

    on<CommentEventDeleteComment>((event, emit) async {
      print('CommentBloc: Handling CommentEventDeleteComment - commentId: ${event.commentId}');
      emit(const CommentStateLoading());

      Either<CommentFailure, Unit> result =
          await commentRepositoryInterface.deleteComment(event.commentId);

      result.fold(
        (l) {
          print('CommentBloc: Failed to delete comment - $l');
          emit(CommentStateFailure(l));
        },
        (r) {
          print('CommentBloc: Successfully deleted comment - commentId: ${event.commentId}');
          emit(const CommentStateDeleted());
        },
      );
    });
  }
}