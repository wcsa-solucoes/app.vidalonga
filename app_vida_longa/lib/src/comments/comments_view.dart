import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/comments/bloc/comments_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({super.key});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final CommentsBloc _commentsBloc = Modular.get<CommentsBloc>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return CustomAppScaffold(
      appBar: const DefaultAppBar(title: "Comentários", isWithBackButton: true),
      body: BlocBuilder<CommentsBloc, CommentsState>(
        bloc: _commentsBloc,
        builder: (context, state) {
          if (state is CommentsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CommentsLoadedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  state.comments.isEmpty
                      ? const DefaultText("Não há comentários nesse artigo!")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            var isCommentFromAuthor = comment.authorId ==
                                UserService.instance.user.id;
                            return ListTile(
                              title: Text(comment.author),
                              subtitle: Text(comment.text),
                              trailing: !isCommentFromAuthor
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _commentsBloc
                                            .add(DeleteCommentEvent(comment));
                                      },
                                    ),
                            );
                          },
                        ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("Erro ao carregar os dados."),
          );
        },
      ),
      bottomNavigationBar: _bottomNavigationBar(keyboardHeight, context),
    );
  }

  Widget _bottomNavigationBar(double keyboardHeight, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    //disabled
                    enabled: !(UserService.instance.status ==
                        UserServiceStatusEnum.loggedOut),
                    controller: _commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Permite um número ilimitado de linhas
                    minLines: 1, // Mínimo de uma linha
                    decoration: InputDecoration(
                      hintText: UserService.instance.status ==
                              UserServiceStatusEnum.loggedOut
                          ? "Logue para poder comentar."
                          : "Adicione um comentário.",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: UserService.instance.status ==
                        UserServiceStatusEnum.loggedOut
                    ? 0.5
                    : 1,
                child: AbsorbPointer(
                  absorbing: UserService.instance.status ==
                      UserServiceStatusEnum.loggedOut,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _commentsBloc
                          .add(CreateCommentEvent(_commentController.text));
                      _commentController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
