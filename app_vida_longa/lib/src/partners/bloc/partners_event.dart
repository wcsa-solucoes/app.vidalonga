part of 'partners_bloc.dart';

@immutable
sealed class PartnersEvent {}

class PartnersLoadedEvent extends PartnersEvent {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchsChip;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnersLoadedEvent({
    required this.partners,
    required this.branchsChip,
    required this.highlightedPartners,
  });
}

class PartnersLoadingEvent extends PartnersEvent {
  PartnersLoadingEvent();
}

class PartnersSearchEvent extends PartnersEvent {
  final String searchTerm;
  PartnersSearchEvent(this.searchTerm);
}

class RestartPartnersEvent extends PartnersEvent {
  RestartPartnersEvent();
}

class PartnerBranchSelectedEvent extends PartnersEvent {
  final List<List<PartnerCompanyModel>> partners;
  final List<ChipCategorieModel> branchsChip;
  final List<PartnerCompanyModel> highlightedPartners;

  PartnerBranchSelectedEvent({
    required this.partners,
    required this.branchsChip,
    required this.highlightedPartners,
  });
}

class SelectPartnerEvent extends PartnersEvent {
  final PartnerCompanyModel partner;
  SelectPartnerEvent(this.partner);
}

class ErrorEvent extends PartnersEvent {
  final String message;
  ErrorEvent(this.message);
}
