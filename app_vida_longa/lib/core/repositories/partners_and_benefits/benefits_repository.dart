import 'package:app_vida_longa/core/controllers/we_exception.dart';
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

    //find the docs that match the benefitsId

    await Future.wait(
      benefitsId.map(
        (benefitiId) async {
          await firestore
              .collection("benefits")
              .where('uuid', isEqualTo: benefitiId)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              benefits.add(BenefitModel.fromMap(value.docs.first.data()));
            }
          }).onError((error, stackTrace) {
            response = WeException.handle(error);
            response.message = "Erro ao buscar os benefícios.";
          });
        },
      ),
    );

    // await firestore
    //     .collection("benefits")
    //     .where(
    //       "partnersId",
    //       arrayContains: partnerId,
    //     )
    //     .get();

    // benefitsId.forEach((element) async {
    //   await firestore
    //       .collection("benefit")
    //       .where('uuid', isEqualTo: element)
    //       .get();
    // });

    return (response: response, benefits: benefits);
  }
}
