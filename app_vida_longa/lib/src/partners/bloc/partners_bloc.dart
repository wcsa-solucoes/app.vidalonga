import 'package:app_vida_longa/core/services/partners_and_benefits/branchs_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/domain/models/branch_model.dart';
import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'partners_event.dart';
part 'partners_state.dart';

class PartnersBloc extends Bloc<PartnersEvent, PartnersState> {
  final IPartnerService _partnerService = PartnerServiceImpl.instance;
  final IBranchsService _branchsService = BranchsServiceImpl.instance;

  PartnersBloc() : super(PartnersLoadingState()) {
    on<PartnersLoadingEvent>(_handleLoading);
    on<PartnersLoadedEvent>(_handleLoaded);
    on<PartnerBranchSelectedEvent>(_handleBranchSelected);
    on<PartnersSearchEvent>(_handleSearchFromTitle);
    on<RestartPartnersEvent>(_handleRestartPartners);
    on<SelectPartnerEvent>(_handleSelectPartner);

    if (_partnerService.partnerCompanies.isNotEmpty) {
      // add(BenefitsLoadedEvent(benefits: test, chipsCategorie: test2));
      add(PartnersLoadedEvent(
        partners: _partners,
        branchsChip: _allBranchesChip,
        highlightedPartners: _highlightedPartners,
      ));
    } else {
      add(PartnersLoadingEvent());
    }
  }

  List<PartnerCompanyModel> get _highlightedPartners =>
      _partnerService.partnerCompanies
          .where((element) => element.isHighlighted)
          .toList();

  List<List<PartnerCompanyModel>> get _partners =>
      _partnerService.partnerCompanies.fold<List<List<PartnerCompanyModel>>>(
          <List<PartnerCompanyModel>>[], (previousValue, element) {
        //
        final List<PartnerCompanyModel>? foundList =
            previousValue.firstWhereOrNull(
          (list) => list.first.branchesId.first == element.branchesId.first,
        );

        if (foundList != null) {
          foundList.add(element);
        } else {
          previousValue.add(<PartnerCompanyModel>[element]);
        }
        return previousValue;
      });

  List<ChipCategorieModel> get _allBranchesChip {
    return _branchsService.branchs
        .map(
          (e) => ChipCategorieModel(
            label: e.name,
            selected: false,
            uuid: e.id,
          ),
        )
        .toList();
  }

  String getBranchName(String branchId) {
    final branch = _branchsService.branchs
        .firstWhere((BranchModel element) => element.id == branchId);
    return branch.name;
  }

  void _handleLoading(PartnersLoadingEvent event, Emitter<PartnersState> emit) {
    emit(PartnersLoadingState());
  }

  void _handleLoaded(PartnersLoadedEvent event, Emitter<PartnersState> emit) {
    emit(
      PartnersLoadedState(
        partners: event.partners,
        branchsChip: event.branchsChip,
        highlightedPartners: event.highlightedPartners,
      ),
    );
  }

  void _handleBranchSelected(
      PartnerBranchSelectedEvent event, Emitter<PartnersState> emit) {
    emit(
      BranchsSelectedLoadedState(
        branchsChip: event.branchsChip,
        parntersByBranch: _partners,
        partnersByBranchSelected: event.partners,
      ),
    );
  }

  void _handleSearchFromTitle(
      PartnersSearchEvent event, Emitter<PartnersState> emit) async {
    emit(PartnersLoadingState());

    final List<String> branchesId = _branchsService.branchs
        .where(
          (branch) => branch.name.toLowerCase().contains(
                event.searchTerm.toLowerCase(),
              ),
        )
        .map((e) => e.id)
        .toList();

    final List<List<PartnerCompanyModel>> tempArticles = [];

    for (var element in _partners) {
      final List<PartnerCompanyModel> temp = element
          .where((element) =>
              branchesId.contains(element.branchesId.first) ||
              element.name
                  .toLowerCase()
                  .contains(event.searchTerm.toLowerCase()) ||
              element.fullAddress!
                  .toLowerCase()
                  .contains(event.searchTerm.toLowerCase()))
          .toList();
      if (temp.isNotEmpty) {
        tempArticles.add(temp);
      }
    }

    emit(PartnersLoadedState(
      partners: tempArticles,
      branchsChip: _allBranchesChip,
      highlightedPartners: const [],
    ));
  }

  void _handleRestartPartners(
      RestartPartnersEvent event, Emitter<PartnersState> emit) {
    emit(PartnersLoadedState(
      partners: _partners,
      branchsChip: _allBranchesChip,
      highlightedPartners: _highlightedPartners,
    ));
  }

  void _handleSelectPartner(
      SelectPartnerEvent event, Emitter<PartnersState> emit) {
    _partnerService.selectPartner(event.partner);
  }
}
