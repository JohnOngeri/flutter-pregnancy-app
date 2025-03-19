import 'package:frontend/domain/comment/comment.dart';

class CommentEvent {
  const CommentEvent._();

  const factory CommentEvent.getCommentsForPost(String postId) = CommentEventGetCommentsForPost;
  const factory CommentEvent.getComments() = CommentEventGetComments;
  const factory CommentEvent.getUserComments(String userid) = CommentEventGetUserComments;
  const factory CommentEvent.addComment(CommentForm commentForm) = CommentEventAddComment;
  const factory CommentEvent.updateComment(CommentForm commentForm, String commentId) =
      CommentEventUpdateComment;
  const factory CommentEvent.deleteComment(String commentId) = CommentEventDeleteComment;

  String get errorMessage {
    if (this is CommentEventGetCommentsForPost) {
      print('CommentEvent: Failed to get comments for post');
      return 'Failed to get comments for post';
    } else if (this is CommentEventGetComments) {
      print('CommentEvent: Failed to get comments');
      return 'Failed to get comments';
    } else if (this is CommentEventGetUserComments) {
      print('CommentEvent: Failed to get user comments');
      return 'Failed to get user comments';
    } else if (this is CommentEventAddComment) {
      print('CommentEvent: Failed to add comment');
      return 'Failed to add comment';
    } else if (this is CommentEventUpdateComment) {
      print('CommentEvent: Failed to update comment');
      return 'Failed to update comment';
    } else if (this is CommentEventDeleteComment) {
      print('CommentEvent: Failed to delete comment');
      return 'Failed to delete comment';
    } else {
      print('CommentEvent: Unknown error');
      return 'Unknown error';
    }
  }
}

class CommentEventGetCommentsForPost extends CommentEvent {
  final String postId;

  const CommentEventGetCommentsForPost(this.postId) : super._();

  @override
  String toString() {
    print('CommentEventGetCommentsForPost: postId = $postId');
    return 'CommentEventGetCommentsForPost(postId: $postId)';
  }
}

class CommentEventGetComments extends CommentEvent {
  const CommentEventGetComments() : super._();

  @override
  String toString() {
    print('CommentEventGetComments: Fetching all comments');
    return 'CommentEventGetComments()';
  }
}

class CommentEventGetUserComments extends CommentEvent {
  final String userid;

  const CommentEventGetUserComments(this.userid) : super._();

  @override
  String toString() {
    print('CommentEventGetUserComments: userid = $userid');
    return 'CommentEventGetUserComments(userid: $userid)';
  }
}

class CommentEventAddComment extends CommentEvent {
  final CommentForm commentForm;

  const CommentEventAddComment(this.commentForm) : super._();

  @override
  String toString() {
    print('CommentEventAddComment: commentForm = $commentForm');
    return 'CommentEventAddComment(commentForm: $commentForm)';
  }
}

class CommentEventUpdateComment extends CommentEvent {
  final CommentForm commentForm;
  final String commentId;

  const CommentEventUpdateComment(this.commentForm, this.commentId) : super._();

  @override
  String toString() {
    print('CommentEventUpdateComment: commentForm = $commentForm, commentId = $commentId');
    return 'CommentEventUpdateComment(commentForm: $commentForm, commentId: $commentId)';
  }
}

class CommentEventDeleteComment extends CommentEvent {
  final String commentId;

  const CommentEventDeleteComment(this.commentId) : super._();

  @override
  String toString() {
    print('CommentEventDeleteComment: commentId = $commentId');
    return 'CommentEventDeleteComment(commentId: $commentId)';
  }
}