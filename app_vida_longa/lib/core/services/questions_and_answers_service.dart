import 'dart:async';

import 'package:app_vida_longa/core/helpers/time_format_helper.dart';
import 'package:app_vida_longa/core/repositories/questions_and_answers_repository.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';

abstract class IQAService {
  Future<ResponseStatusModel> getAll();
  Future<void> init(IQARepository qaRepository);
  List<QuestionAnswerModel> get qaList;
  Future<ResponseStatusModel> addQuestion(String question, bool isAnonymous);
}

class QAServiceImpl extends IQAService {
  QAServiceImpl._internal();
  static final QAServiceImpl _instance = QAServiceImpl._internal();
  static QAServiceImpl get instance => _instance;

  final List<QuestionAnswerModel> _qaList = [];

  late IQARepository _qaRepository;

  @override
  Future<ResponseStatusModel> getAll() async {
    final (:response, :qaList) = await _qaRepository.getAll();

    if (response.status == ResponseStatusEnum.success) {
      _setQaList(qaList);
    }
    return response;
  }

  bool _hasInit = false;

  @override
  Future<void> init(qaRepository) async {
    _qaRepository = qaRepository;
    if (_hasInit) {
      return;
    }
    _hasInit = true;
    await getAll();

    return;
  }

  void _setQaList(List<QuestionAnswerModel> qaList) {
    _qaList.clear();
    _qaList.addAll(qaList);
  }

  void _addQuestion(QuestionAnswerModel question) {
    _qaList.insert(0, question);
  }

  @override
  List<QuestionAnswerModel> get qaList => _qaList;

  @override
  Future<ResponseStatusModel> addQuestion(
      String question, bool isAnonymous) async {
    final QuestionAnswerModel newQuestion = QuestionAnswerModel.newQuestion(
      question: question,
      isAnonymous: isAnonymous,
      createdAt: TimeHelper.dateTimeNowToDDMMYYHHMMSS(),
      userId: UserService.instance.user.id,
    );

    final response = await _qaRepository.addQuestion(newQuestion);

    if (response.status == ResponseStatusEnum.success) {
      _addQuestion(newQuestion);
    }
    return response;
  }
}
