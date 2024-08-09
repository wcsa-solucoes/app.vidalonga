part of 'partners_bloc.dart';

@immutable
sealed class PartnersState {}

final class PartnersInitial extends PartnersState {}

final class PartnersLoadingState extends PartnersState {}

final class PartnersLoadedState extends PartnersState {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchs;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersLoadedState({
    required this.partners,
    required this.branchs,
    required this.highlightedPartners,
  });
}

class PartnersSearchedState extends PartnersState {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchs;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersSearchedState({
    required this.partners,
    required this.branchs,
    required this.highlightedPartners,
  });
}

class PartnersByBranchSelectedLoadedState extends PartnersState {
  final ChipCategorieModel branch;
  final List<PartnerCompanyModel> parntersByBranch;

  PartnersByBranchSelectedLoadedState({
    required this.branch,
    required this.parntersByBranch,
  });
}

class PartnersErrorState extends PartnersState {
  final String message;
  PartnersErrorState(this.message);
}
