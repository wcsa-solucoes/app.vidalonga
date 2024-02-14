import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPlansRepository {
  Future<({ResponseStatusModel response, List<PlanModel> plans})> getPlans();
}

class PlansRepositoryImpl implements IPlansRepository {
  final FirebaseFirestore _firestore;
  PlansRepositoryImpl(
    this._firestore,
  );

  @override
  Future<({ResponseStatusModel response, List<PlanModel> plans})>
      getPlans() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<PlanModel> plans = [];

    await _firestore.collection('plans').get().then((value) {
      for (var element in value.docs) {
        plans.add(PlanModel.fromMap(element.data()));
      }
    }).onError((Object? object, error) {
      response = ResponseStatusModel(
        message: 'Erro ao buscar os planos',
        status: ResponseStatusEnum.error,
      );
    });
    return (response: response, plans: plans);
  }
}
