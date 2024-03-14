import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/benefit_category_model.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBenefitsRepository {
  Future<({ResponseStatusModel response, List<BenefitModel> benefits})>
      getAll();
  Future<
      ({
        ResponseStatusModel response,
        List<BenefitCategoryModel> categories
      })> getBenefitCategories();
}

class BenefitsRepositoryImpl extends IBenefitsRepository {
  FirebaseFirestore firestore;
  BenefitsRepositoryImpl({required this.firestore});

  @override
  Future<({ResponseStatusModel response, List<BenefitModel> benefits})>
      getAll() async {
    ResponseStatusModel response = ResponseStatusModel();

    List<BenefitModel> benefits = [];

    await firestore.collection('benefits').get().then((value) {
      if (value.docs.isNotEmpty) {
        benefits = value.docs
            .map((e) => BenefitModel.fromMap(
                  e.data(),
                ))
            .toList();
        response.status = ResponseStatusEnum.success;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
      response.message = "Erro ao buscar os benefícios.";
    });

    return (response: response, benefits: benefits);
  }

  @override
  Future<
      ({
        ResponseStatusModel response,
        List<BenefitCategoryModel> categories
      })> getBenefitCategories() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<BenefitCategoryModel> categories = [];

    await firestore.collection('benefitCategories').get().then((value) {
      if (value.docs.isNotEmpty) {
        categories = value.docs
            .map((e) => BenefitCategoryModel.fromMap(
                  e.data(),
                ))
            .toList();
        response.status = ResponseStatusEnum.success;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
      response.message = "Erro ao buscar as categorias dos benefícios.";
    });

    return (response: response, categories: categories);
  }
}
