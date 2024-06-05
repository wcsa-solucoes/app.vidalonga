import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBenefitsRepository {
  Future<({List<BenefitModel> benefits, ResponseStatusModel response})>
      getAllBenefitsByPartner(String partnerId, List<String> benefitsId);
}

class BenefitsRepositoryImpl extends IBenefitsRepository {
  FirebaseFirestore firestore;
  BenefitsRepositoryImpl({required this.firestore});

  @override
  Future<({List<BenefitModel> benefits, ResponseStatusModel response})>
      getAllBenefitsByPartner(String partnerId, benefitsId) async {
    ResponseStatusModel response = ResponseStatusModel();
    List<BenefitModel> benefits = [];

    await firestore
        .collection("benefits")
        .where("partnerCompaniesUuid", arrayContains: partnerId)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            benefits.add(BenefitModel.fromMap(element.data()));
          }
        }
      },
    );

    return (response: response, benefits: benefits);
  }
}
