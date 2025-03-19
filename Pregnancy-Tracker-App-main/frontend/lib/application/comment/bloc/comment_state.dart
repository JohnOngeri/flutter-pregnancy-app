import 'package:frontend/domain/comment/comment.dart';

class CommentState {
  const CommentState._();

  const factory CommentState.initial() = CommentStateInitial;

  const factory CommentState.loading() = CommentStateLoading;

  const factory CommentState.success(CommentDomain comment) = CommentStateSuccess;

  const factory CommentState.successMultiple(List<CommentDomain> comments) =
      CommentStateSuccessMultiple;

  const factory CommentState.failure(CommentFailure failure) = CommentStateFailure;

  const factory CommentState.deleted() = CommentStateDeleted;

  CommentState copyWith({
    List<CommentDomain>? comments,
    CommentFailure? failure,
    CommentDomain? comment,
  }) {
    if (comments != null) {
      print('CommentState: Copying with comments - ${comments.length} comments');
      return CommentState.successMultiple(comments);
    } else if (failure != null) {
      print('CommentState: Copying with failure - $failure');
      return CommentState.failure(failure);
    } else if (comment != null) {
      print('CommentState: Copying with comment - ${comment.id}');
      return CommentState.success(comment);
    } else {
      print('CommentState: Copying with no changes');
      return this;
    }
  }
}

class CommentStateInitial extends CommentState {
  const CommentStateInitial() : super._();

  @override
  String toString() {
    print('CommentStateInitial: Created');
    return 'CommentStateInitial()';
  }
}

class CommentStateLoading extends CommentState {
  const CommentStateLoading() : super._();

  @override
  String toString() {
    print('CommentStateLoading: Created');
    return 'CommentStateLoading()';
  }
}

class CommentStateSuccess extends CommentState {
  final CommentDomain comment;

  const CommentStateSuccess(this.comment) : super._();

  @override
  String toString() {
    print('CommentStateSuccess: Created with comment - ${comment.id}');
    return 'CommentStateSuccess(comment: $comment)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentStateSuccess &&
          runtimeType == other.runtimeType &&
          comment == other.comment;

  @override
  int get hashCode => runtimeType.hashCode ^ comment.hashCode;
}

class CommentStateSuccessMultiple extends CommentState {
  final List<CommentDomain> comments;

  const CommentStateSuccessMultiple(this.comments) : super._();

  @override
  String toString() {
    print('CommentStateSuccessMultiple: Created with ${comments.length} comments');
    return 'CommentStateSuccessMultiple(comments: $comments)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentStateSuccessMultiple &&
          runtimeType == other.runtimeType &&
          comments == other.comments;

  @override
  int get hashCode => runtimeType.hashCode ^ comments.hashCode;
}

class CommentStateFailure extends CommentState {
  final CommentFailure failure;

  const CommentStateFailure(this.failure) : super._();

  @override
  String toString() {
    print('CommentStateFailure: Created with failure - $failure');
    return 'CommentStateFailure(failure: $failure)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentStateFailure &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => runtimeType.hashCode ^ failure.hashCode;
}

class CommentStateDeleted extends CommentState {
  const CommentStateDeleted() : super._();

  @override
  String toString() {
    print('CommentStateDeleted: Created');
    return 'CommentStateDeleted()';
  }
}