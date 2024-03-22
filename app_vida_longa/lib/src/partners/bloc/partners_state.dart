part of 'partners_bloc.dart';

@immutable
sealed class PartnersState {}

final class PartnersInitial extends PartnersState {}

final class PartnersLoadingState extends PartnersState {}

final class PartnersLoadedState extends PartnersState {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchsChip;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersLoadedState({
    required this.partners,
    required this.branchsChip,
    required this.highlightedPartners,
  });
}

class BranchsSelectedLoadedState extends PartnersState {
  final List<List<PartnerCompanyModel>> partnersByBranchSelected;
  final List<ChipCategorieModel> branchsChip;
  final List<List<PartnerCompanyModel>> parntersByBranch;

  BranchsSelectedLoadedState({
    required this.partnersByBranchSelected,
    required this.branchsChip,
    required this.parntersByBranch,
  });
}

class PartnersErrorState extends PartnersState {
  final String message;
  PartnersErrorState(this.message);
}
