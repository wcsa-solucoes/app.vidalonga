part of 'partners_bloc.dart';

@immutable
sealed class PartnersEvent {}

class PartnersLoadedEvent extends PartnersEvent {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchs;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersLoadedEvent({
    required this.partners,
    required this.branchs,
    required this.highlightedPartners,
  });
}

class PartnersLoadingEvent extends PartnersEvent {
  PartnersLoadingEvent();
}

class ResetPartnersBranchSelectedEvent extends PartnersEvent {
  ResetPartnersBranchSelectedEvent();
}

class PartnersSearchEvent extends PartnersEvent {
  final String searchTerm;
  PartnersSearchEvent(this.searchTerm);
}

class RestartPartnersEvent extends PartnersEvent {
  RestartPartnersEvent();
}

class PartnersByBranchSelectedEvent extends PartnersEvent {
  final List<PartnerCompanyModel> partners;
  final ChipCategorieModel branch;

  PartnersByBranchSelectedEvent({
    required this.partners,
    required this.branch,
  });
}

class SelectPartnerEvent extends PartnersEvent {
  final PartnerCompanyModel partner;
  SelectPartnerEvent(this.partner);
}

class SelectBranchEvent extends PartnersEvent {
  final ChipCategorieModel branch;
  SelectBranchEvent(this.branch);
}

class ErrorEvent extends PartnersEvent {
  final String message;
  ErrorEvent(this.message);
}
