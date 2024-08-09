part of 'partners_by_branch_bloc.dart';

sealed class PartnersByBranchEvent {}

class PartnersByBranchLoadedEvent extends PartnersByBranchEvent {
  // final List<PartnerCompanyModel> partners;
  // final BranchModel branch;

  PartnersByBranchLoadedEvent();
}

class PartnersByBranchLoadingEvent extends PartnersByBranchEvent {
  final String branchId;

  PartnersByBranchLoadingEvent(this.branchId);
}

class PartnersByBranchSearchEvent extends PartnersByBranchEvent {
  final String searchTerm;
  PartnersByBranchSearchEvent(this.searchTerm);
}

class RestartPartnersByBranchEvent extends PartnersByBranchEvent {
  RestartPartnersByBranchEvent();
}

class PartnersByBranchEmptyEvent extends PartnersByBranchEvent {
  PartnersByBranchEmptyEvent();
}

class SelectPartnerByBranchEvent extends PartnersByBranchEvent {
  final PartnerCompanyModel partner;
  SelectPartnerByBranchEvent(this.partner);
}

class ErrorEvent extends PartnersByBranchEvent {
  final String message;
  ErrorEvent(this.message);
}
