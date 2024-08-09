part of 'partners_by_branch_bloc.dart';

@immutable
sealed class PartnersByBranchState {}

final class PartnersByBranchInitial extends PartnersByBranchState {}

final class PartnersByBranchLoadingState extends PartnersByBranchState {}

final class PartnersByBranchEmptyState extends PartnersByBranchState {}

final class PartnersByBranchLoadedState extends PartnersByBranchState {
  final List<PartnerCompanyModel> partners;
  final BranchModel branch;

  PartnersByBranchLoadedState({
    required this.partners,
    required this.branch,
  });
}

class PartnersByBranchSearchedState extends PartnersByBranchState {
  final List<PartnerCompanyModel> partners;
  final List<ChipCategorieModel> branchs;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersByBranchSearchedState({
    required this.partners,
    required this.branchs,
    required this.highlightedPartners,
  });
}

class PartnersByBranchErrorState extends PartnersByBranchState {
  final String message;
  PartnersByBranchErrorState(this.message);
}
