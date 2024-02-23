import 'dart:async';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class SomeQuestionView extends StatefulWidget {
  final QuestionAnswerModel question;
  const SomeQuestionView({super.key, required this.question});

  @override
  State<SomeQuestionView> createState() => _SomeQuestionViewState();
}

class _SomeQuestionViewState extends State<SomeQuestionView> {
  double fontSize = 16.0;
  List<Widget> answers = [];

  final StreamController<double> _streamControllerFontSize =
      StreamController.broadcast();
  @override
  void initState() {
    super.initState();
    for (var item in widget.question.answers) {
      if (item.type == "text") {
        answers.add(
          StreamBuilder<double>(
            initialData: fontSize,
            stream: _streamControllerFontSize.stream,
            builder: ((context, snapshot) {
              return Html(
                style: {"body": Style(fontSize: FontSize(snapshot.data!))},
                data: item.answer,
              );
            }),
          ),
        );
      } else {
        answers.add(
          Html(extensions: const [
            IframeHtmlExtension(),
          ], data: item.answer),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          "Pergunta",
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        DefaultText(
          widget.question.question,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        const SizedBox(height: 16),
        _handleAnswers(),
      ],
    );
  }

  Widget _handleAnswers() {
    if (answers.isEmpty) {
      return const DefaultText(
        "Essa pergunta ainda não foi respondida.",
        fontSize: 16,
        fontWeight: FontWeight.w300,
      );
    }

    return Column(
      children: answers,
    );
  }
}
