part of 'comments_bloc.dart';

@immutable
sealed class CommentsState {}

final class CommentsInitialState extends CommentsState {}

final class CommentsLoadingState extends CommentsState {}

final class CommentsLoadedState extends CommentsState {
  final List<CommentModel> comments;

  CommentsLoadedState(this.comments);
}
