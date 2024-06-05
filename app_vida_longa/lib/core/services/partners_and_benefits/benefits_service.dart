import 'dart:async';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/repositories/partners_and_benefits/benefits_repository.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBenefitsService {
  Future<ResponseStatusModel> getAllBenefitsByPartner(
      String partnerId, List<String> benefitsId);
  List<BenefitModel> get benefitsFromSelectedPartner;

  Stream<List<BenefitModel>> get benefitsStream;
}

class BenefitisServiceImpl extends IBenefitsService {
  BenefitisServiceImpl.internal();

  static final IBenefitsService _instance = BenefitisServiceImpl.internal();

  static IBenefitsService get instance => _instance;

  final IBenefitsRepository _benefitsRepository =
      BenefitsRepositoryImpl(firestore: FirebaseFirestore.instance);

  final Map<String, List<BenefitModel>> _benefits = {};

  final List<BenefitModel> _benefitsSelected = [];
  @override
  List<BenefitModel> get benefitsFromSelectedPartner => _benefitsSelected;

  String lastPartnerId = "";

  final StreamController<List<BenefitModel>> _benefitsStreamController =
      StreamController<List<BenefitModel>>.broadcast();

  @override
  Stream<List<BenefitModel>> get benefitsStream =>
      _benefitsStreamController.stream;

  @override
  Future<ResponseStatusModel> getAllBenefitsByPartner(
      String partnerId, List<String> benefitsId) async {
    //check if the partnerId is the same as the last one
    if (lastPartnerId == partnerId) {
      _updateBenefitsSelected(_benefits[partnerId]!);
      return ResponseStatusModel(status: ResponseStatusEnum.success);
    }

    lastPartnerId = partnerId;

    if (_benefits.containsKey(partnerId)) {
      var benefits = _benefits[partnerId]!;
      _benefitsStreamController.sink.add(benefits);
      // _updateBenefitsSelected(benefits);

      return ResponseStatusModel(status: ResponseStatusEnum.success);
    }

    final (:response, :benefits) = await _benefitsRepository
        .getAllBenefitsByPartner(partnerId, benefitsId);

    if (response.status == ResponseStatusEnum.success) {
      _setBenefits(benefits, partnerId);
      return response;
    }
    AppHelper.displayAlertError("Erro ao buscar os benefícios.");

    return response;
  }

  void _setBenefits(List<BenefitModel> benefits, String partnerId) {
    _benefitsSelected.clear();
    _benefitsSelected.addAll(benefits);
    _benefits[partnerId] = benefits;
    _benefitsStreamController.sink.add(_benefitsSelected);
  }

  void _updateBenefitsSelected(List<BenefitModel> benefits) {
    _benefitsSelected.clear();
    _benefitsSelected.addAll(benefits);
    _benefitsStreamController.sink.add(_benefitsSelected);
  }
}
