import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/questions_and_answers/bloc/qa_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NewQuestionView extends StatefulWidget {
  const NewQuestionView({super.key});

  @override
  State<NewQuestionView> createState() => _NewQuestionViewState();
}

class _NewQuestionViewState extends State<NewQuestionView> {
  final TextEditingController _newQuestionTxtEdtCtrl = TextEditingController();
  late final QABloc _qaBloc;

  @override
  void initState() {
    _qaBloc = ReadContext(context).read<QABloc>();
    super.initState();
  }

  @override
  void dispose() {
    _qaBloc.add(LoadedQuestionsEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          "Nova pergunta",
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        //back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: body(),
    );
  }

  bool switchValue = false;

  Widget body() {
    return BlocConsumer<QABloc, QAState>(
      listener: (context, state) {
        if (state is QuestionAdded) {
          _newQuestionTxtEdtCtrl.clear();
        }
      },
      bloc: _qaBloc,
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              DecoratedTextFieldWidget(
                controller: _newQuestionTxtEdtCtrl,
                labelText: "Nova pergunta",
                hintText: "Nova pergunta",
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FlutterSwitch(
                        height: 30.0,
                        value: switchValue,
                        activeIcon: const Icon(
                          Icons.lock,
                          color: AppColors.selectedColor,
                        ),
                        inactiveIcon: const Icon(
                          Icons.lock_open,
                          color: AppColors.selectedColor,
                        ),
                        activeColor: AppColors.selectedColor,
                        onToggle: (val) {
                          setState(() {
                            switchValue = val;
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Tooltip(
                          message:
                              "Somente você e o profissional sabe quem fez a pergunta",
                          child: DefaultText(
                            "Anônima? ",
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 90,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.selectedColor,
                      ),
                      child: Builder(builder: (context) {
                        if (state is QALoading) {
                          return const Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            ),
                          );
                        }

                        return IconButton(
                          onPressed: () async {
                            if (_newQuestionTxtEdtCtrl.text.isEmpty) {
                              AppHelper.displayAlertInfo("Preencha a pergunta");
                            }
                            _qaBloc.add(
                              AddQuestionEvent(
                                _newQuestionTxtEdtCtrl.text,
                                switchValue,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.send,
                            color: AppColors.white,
                            size: 18,
                          ),
                        );
                      }))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
