import 'package:app_vida_longa/core/repositories/benefits_repository.dart';
import 'package:app_vida_longa/domain/models/benefit_category_model.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

abstract class IBenefitsService {
  List<BenefitCategoryModel> get categories;
  List<BenefitModel> get benefits;

  Future<void> init();

  Future<void> getAll();

  Future<void> getBenefitCategories();
}

class BenefitisServiceImpl extends IBenefitsService {
  BenefitisServiceImpl.internal();

  static final IBenefitsService _instance = BenefitisServiceImpl.internal();

  static IBenefitsService get instance => _instance;

  final IBenefitsRepository _benefitsRepository =
      BenefitsRepositoryImpl(firestore: FirebaseFirestore.instance);

  final List<BenefitModel> _benefits = [];

  @override
  List<BenefitModel> get benefits => _benefits;

  final List<BenefitCategoryModel> _categories = [];

  @override
  Future<void> init() async {
    await getBenefitCategories();
    await getAll();
  }

  @override
  Future<void> getAll() async {
    final (:response, :benefits) = await _benefitsRepository.getAll();

    if (response.status == ResponseStatusEnum.success) {
      setBenefits(benefits);
    }
  }

  void setBenefits(List<BenefitModel> benefits) {
    List<BenefitModel> temp = [];

    //get the title from the categories
    for (var benefit in benefits) {
      BenefitCategoryModel? category = _categories
          .firstWhereOrNull((element) => element.id == benefit.categoryId);

      if (category != null) {
        benefit = benefit.copyWith(categoryTitle: category.name);
      }
      temp.add(benefit);
    }

    _benefits.clear();
    _benefits.addAll(temp);
  }

  void _setCategories(List<BenefitCategoryModel> categories) {
    _categories.clear();
    _categories.addAll(categories);
  }

  @override
  Future<void> getBenefitCategories() async {
    final (:response, :categories) =
        await _benefitsRepository.getBenefitCategories();

    if (response.status == ResponseStatusEnum.success) {
      _setCategories(categories);
    }
  }

  @override
  List<BenefitCategoryModel> get categories => _categories;
}
