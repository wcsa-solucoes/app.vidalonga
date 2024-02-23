import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IQARepository {
  Future<({ResponseStatusModel response, List<QuestionAnswerModel> qaList})>
      getAll();
}

class QARepositoryImpl extends IQARepository {
  FirebaseFirestore firestore;

  QARepositoryImpl(this.firestore);

  @override
  Future<({ResponseStatusModel response, List<QuestionAnswerModel> qaList})>
      getAll() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<QuestionAnswerModel> qaList = [];

    await firestore.collection('questions').get().then((value) {
      if (value.docs.isEmpty) {
        return;
      }

      for (var element in value.docs) {
        qaList.add(QuestionAnswerModel.fromMap(element.data()));
      }
    }).onError((Object? object, StackTrace error) {
      response = ResponseStatusModel(
        message: 'Erro ao buscar os planos',
        status: ResponseStatusEnum.error,
      );
    });
    return (response: response, qaList: qaList);
  }
}
