import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/open_button_page.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:app_vida_longa/src/questions_and_answers/bloc/qa_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsAndAnswersView extends StatefulWidget {
  const QuestionsAndAnswersView({super.key});

  @override
  State<QuestionsAndAnswersView> createState() =>
      _QuestionsAndAnswersViewState();
}

class _QuestionsAndAnswersViewState extends State<QuestionsAndAnswersView>
    with SingleTickerProviderStateMixin {
  final QABloc _qaBloc = QABloc();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _qaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/AVATAR_(1).png",
                    width: 60,
                  ),
                  const DefaultText(
                    "Perguntas",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottom: TabBar(
            indicatorColor: AppColors.selectedColor,
            labelColor: AppColors.selectedColor,
            unselectedLabelColor: AppColors.primaryText,
            labelStyle: GoogleFonts.getFont(
              'Urbanist',
              color: AppColors.dimGray,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
            tabs: const [
              Tab(
                  icon: DefaultText(
                "Todas perguntas",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              )),
              Tab(
                icon: DefaultText(
                  "Minhas perguntas",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              )
            ],
            controller: _tabController),
      ),
      body: body(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton: AuthService.instance.getCurrentUser != null
          ? FloatingActionButton(
              backgroundColor: AppColors.white,
              onPressed: () {
                NavigationController.push(routes.app.qa.newQuestion.path,
                    arguments: _qaBloc);
              },
              child: const FaIcon(
                FontAwesomeIcons.plus,
                color: AppColors.selectedColor,
                size: 20,
              ),
            )
          : null,
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
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              controller: _tabController,
              children: [
                allQuestions(state.questions),
                myQuestions(state.myQuestions),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget myQuestions(List<QuestionAnswerModel> questions) {
    bool isSignIn =
        UserService.instance.status != UserServiceStatusEnum.loggedOut;
    return !isSignIn
        ? const Center(child: DefaultText("Logue para ver as suas perguntas"))
        : allQuestions(questions);
  }

  Widget allQuestions(List<QuestionAnswerModel> questions) {
    if (questions.isEmpty) {
      return const Center(child: DefaultText("Não há perguntas!"));
    }
    return RefreshIndicator(
      onRefresh: () async {
        _qaBloc.add(FetchQuestionsEvent());
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];

                return OpenPageButtonWiget(
                  question.question,
                  onPressed: () {
                    NavigationController.push(routes.app.qa.question.path,
                        arguments: question);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
