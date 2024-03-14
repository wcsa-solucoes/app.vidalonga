part of 'benefits_bloc.dart';

@immutable
sealed class BenefitsEvent {}

class BenefitCategorieSelectedEvent extends BenefitsEvent {
  final List<List<BenefitModel>> benefits;
  final List<ChipCategorieModel> chipsCategorie;

  BenefitCategorieSelectedEvent({
    required this.benefits,
    required this.chipsCategorie,
  });
}

class BenefitsLoadingEvent extends BenefitsEvent {
  BenefitsLoadingEvent();
}

class BenefitsLoadedEvent extends BenefitsEvent {
  final List<List<BenefitModel>> benefits;
  final List<ChipCategorieModel> chipsCategorie;

  BenefitsLoadedEvent({
    required this.benefits,
    required this.chipsCategorie,
  });
}

class RestartBenefitsEvent extends BenefitsEvent {
  RestartBenefitsEvent();
}

class BenefitsSearchEvent extends BenefitsEvent {
  final String searchTerm;

  BenefitsSearchEvent({
    required this.searchTerm,
  });
}
