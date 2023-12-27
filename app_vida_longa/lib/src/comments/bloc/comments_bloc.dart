import 'dart:async';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/comments_service.dart';
import 'package:app_vida_longa/domain/models/comment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentService _service = CommentService.instance;
  final List<CommentModel> _comments = <CommentModel>[];

  CommentsBloc() : super(CommentsLoadingState()) {
    _service
        .getAllCommentsFromArticle(ArticleService.currentlyArticleId)
        .then((value) {
      _comments.clear();
      _comments.addAll(value);
      add(CommentsLoadedEvent(value));
    });
    on<CommentsLoadedEvent>(commentLoaded);
    on<CreateCommentEvent>(createComment);
    on<DeleteCommentEvent>(deleteComment);
  }

  FutureOr<void> commentLoaded(
      CommentsLoadedEvent event, Emitter<CommentsState> emit) {
    emit(CommentsLoadedState(event.comments));
  }

  FutureOr<void> createComment(
      CreateCommentEvent event, Emitter<CommentsState> emit) async {
    await _service.createComment(event.comment);
    AppHelper.displayAlertSuccess("Comentário criado com sucesso!");
    emit(CommentsLoadedState(_service.articles));
  }

  FutureOr<void> deleteComment(
      DeleteCommentEvent event, Emitter<CommentsState> emit) async {
    await _service.deleteComment(event.comment);
    AppHelper.displayAlertSuccess("Comentário deletado com sucesso!");
    emit(CommentsLoadedState(_service.articles));
  }

  FutureOr<void> updateComment(
      UpdateCommentEvent event, Emitter<CommentsState> emit) async {
    await _service.updateComment(event.comment);
    AppHelper.displayAlertSuccess("Comentário atualizado com sucesso!");
    emit(CommentsLoadedState(_service.articles));
  }
}
