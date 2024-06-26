import 'package:app_vida_longa/core/repositories/plans_repository.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPlansService {
  Future<void> getPlans();
  List<PlanModel> get plans;

  late final PlanModel defaultPlan;
  PlanModel getPlanIdByAppleId(String id);
  PlanModel getPlanIdByGoogleId(String id);
}

class PlansServiceImpl implements IPlansService {
  PlansServiceImpl._internal();
  static final PlansServiceImpl _instance = PlansServiceImpl._internal();
  static PlansServiceImpl get instance => _instance;
  final IPlansRepository _plansRepository =
      PlansRepositoryImpl(FirebaseFirestore.instance);

  @override
  PlanModel defaultPlan = PlanModel(
    applePlanId: 'app.vidalongaapp.assinaturamensal',
    googlePlanId: 'com.vidalonga.assinaturamensal',
    name: "Premium",
    price: 29.90,
  );

  final List<PlanModel> _plans = [];

  @override
  Future<void> getPlans() async {
    final (:response, :plans) = await _plansRepository.getPlans();

    if (response.status == ResponseStatusEnum.success) {
      _setPlans(plans);
    }
  }

  void _setPlans(List<PlanModel> plans) {
    _plans.clear();
    _plans.addAll(plans);
  }

  @override
  List<PlanModel> get plans => _plans;

  @override
  PlanModel getPlanIdByAppleId(String id) {
    return _plans.firstWhere(
      (element) => element.applePlanId == id,
      orElse: () => defaultPlan,
    );
  }

  @override
  PlanModel getPlanIdByGoogleId(String id) {
    return _plans.firstWhere(
      (element) => element.googlePlanId == id,
      orElse: () => defaultPlan,
    );
  }
}
