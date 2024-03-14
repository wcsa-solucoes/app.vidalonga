part of 'benefits_bloc.dart';

@immutable
sealed class BenefitsState {}

final class BenefitsInitial extends BenefitsState {}

final class BenefitsLoadingState extends BenefitsState {}

final class BenefitsLoadedState extends BenefitsState {
  final List<List<BenefitModel>> benefits;
  final List<ChipCategorieModel> chipsCategorie;

  BenefitsLoadedState({
    required this.benefits,
    required this.chipsCategorie,
  });
}

class HomeCategoriesSelectedState extends BenefitsState {
  final List<List<BenefitModel>> benefitsByCategorySelected;
  final List<ChipCategorieModel> chipsCategorie;
  final List<List<BenefitModel>> benefitsByCategory;

  HomeCategoriesSelectedState({
    required this.benefitsByCategorySelected,
    required this.chipsCategorie,
    required this.benefitsByCategory,
  });
}
