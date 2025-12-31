import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:app_vida_longa/src/questions_and_answers/bloc/qa_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NewQuestionView extends StatefulWidget {
  final QABloc qaBloc;
  const NewQuestionView({super.key, required this.qaBloc});

  @override
  State<NewQuestionView> createState() => _NewQuestionViewState();
}

class _NewQuestionViewState extends State<NewQuestionView> {
  final TextEditingController _newQuestionTxtEdtCtrl = TextEditingController();
  late final QABloc _qaBloc;
  bool switchValue = false;

  @override
  void initState() {
    _qaBloc = widget.qaBloc;
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
      appBar: const DefaultAppBar(
        title: "Nova pergunta",
        isWithBackButton: true,
      ),
      body: body(),
    );
  }

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
          height: MediaQuery.of(context).size.height * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              DecoratedTextFieldWidget(
                controller: _newQuestionTxtEdtCtrl,
                labelText: "Clique aqui para fazer sua pergunta",
                hintText: "Clique aqui para fazer sua pergunta",
              ),
              const SizedBox(height: 10),
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
                          preferBelow: false,
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
                    width: 145,
                    height: 45.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.selectedColor,
                    ),
                    child: Builder(
                      builder: (context) {
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

                        return TextButton(
                          onPressed: () {
                            if (_newQuestionTxtEdtCtrl.text.isEmpty) {
                              AppHelper.displayAlertInfo("Preencha a pergunta");
                              return;
                            }
                            _qaBloc.add(
                              AddQuestionEvent(
                                _newQuestionTxtEdtCtrl.text,
                                switchValue,
                              ),
                            );
                          },
                          child: const Text(
                            "Enviar pergunta",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.selectedColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.selectedColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        DefaultText(
                          "Importante:",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.selectedColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    DefaultText(
                      "• Você pode fazer até 3 perguntas mensais.",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    DefaultText(
                      "• Tire suas dúvidas sobre saúde, medicamentos, exames, tratamentos ou sintomas.",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    DefaultText(
                      "• Você pode informar sua idade e sexo, solicitando sugestão de exames ou suplementos para ajudar no controle de peso, insônia, ansiedade ou imunidade.",
                      fontSize: 14,
                      maxLines: 4,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8),
                    DefaultText(
                      "• As informações obtidas poderão auxiliar durante uma consulta médica.",
                      maxLines: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  NavigationController.push(
                    routes.app.qa.helthInfo.path,
                    arguments: null,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.selectedColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: DefaultText(
                      "Clique aqui para receber informações de saúde de acordo com seu perfil.",
                      fontSize: 16,
                      maxLines: 3,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
