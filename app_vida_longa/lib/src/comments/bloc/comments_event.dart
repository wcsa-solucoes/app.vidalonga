part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

final class CommentsLoadingEvent extends CommentsEvent {}

final class CommentsLoadedEvent extends CommentsEvent {
  final List<CommentModel> comments;

  CommentsLoadedEvent(this.comments);
}

final class CreateCommentEvent extends CommentsEvent {
  final String comment;

  CreateCommentEvent(this.comment);
}

final class DeleteCommentEvent extends CommentsEvent {
  final CommentModel comment;

  DeleteCommentEvent(this.comment);
}

final class UpdateCommentEvent extends CommentsEvent {
  final CommentModel comment;

  UpdateCommentEvent(this.comment);
}
