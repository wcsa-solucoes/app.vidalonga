import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/open_button_page.dart';
import 'package:app_vida_longa/src/questions_and_answers/bloc/qa_bloc.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/some_question_view.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/question_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsAndAnswersView extends StatefulWidget {
  const QuestionsAndAnswersView({super.key});

  @override
  State<QuestionsAndAnswersView> createState() =>
      _QuestionsAndAnswersViewState();
}

class _QuestionsAndAnswersViewState extends State<QuestionsAndAnswersView> {
  final QABloc _qaBloc = QABloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          "Perguntas e Respostas",
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: body(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget body() {
    return BlocBuilder<QABloc, QAState>(
      bloc: _qaBloc,
      builder: (context, state) {
        if (state is QALoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is QAError) {
          return Center(
            child: DefaultText(state.message),
          );
        }

        if (state is QAInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is QAError) {
          return Center(
            child: DefaultText(state.message),
          );
        }

        if (state is QALoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              _qaBloc.add(FetchQuestionsEvent());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.amber,
              child: Column(
                children: [
                  OpenPageButtonWiget(
                    "Minhas perguntas",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QuestionView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.questions[index];

                        return OpenPageButtonWiget(
                          question.question,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SomeQuestionView(
                                  question: question,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
