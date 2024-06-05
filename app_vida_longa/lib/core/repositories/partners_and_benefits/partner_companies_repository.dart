import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPartnerCompaniesRepository {
  Future<
      ({
        List<PartnerCompanyModel> partnerCompanies,
        ResponseStatusModel response
      })> getAllPartners();
}

class PartnerCompaniesRepositoryImpl extends IPartnerCompaniesRepository {
  FirebaseFirestore firestore;
  PartnerCompaniesRepositoryImpl({required this.firestore});

  @override
  Future<
      ({
        List<PartnerCompanyModel> partnerCompanies,
        ResponseStatusModel response
      })> getAllPartners() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<PartnerCompanyModel> partnerCompanies = [];

    await firestore.collection('partnerCompanies').get().then((value) {
      if (value.docs.isNotEmpty) {
        partnerCompanies = value.docs
            .map((e) => PartnerCompanyModel.fromMap(
                  e.data(),
                ))
            .toList();
        response.status = ResponseStatusEnum.success;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
      response.message = "Erro ao buscar as empresas parceiras.";
    });

    return (response: response, partnerCompanies: partnerCompanies);
  }
}
