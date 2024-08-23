import 'dart:async';
import 'package:app_vida_longa/core/services/partners_and_benefits/branchs_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/core/utils/string_util.dart';
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
  late final StreamSubscription<List<PartnerCompanyModel>> _subscription;

  PartnersBloc() : super(PartnersLoadingState()) {
    on<PartnersLoadingEvent>(_handleLoading);
    on<PartnersLoadedEvent>(_handleLoaded);
    on<PartnersSearchEvent>(_handleSearchFromTitle);
    on<RestartPartnersEvent>(_handleRestartPartners);
    on<SelectPartnerEvent>(_handleSelectPartner);
    on<ErrorEvent>((event, emit) {
      emit(PartnersErrorState(event.message));
    });

    _subscription = _partnerService.companiesStream.listen(
      (event) {
        if (_partnerService.hasLoaded) {
          if (_partnerService.partnerCompanies.isNotEmpty) {
            add(PartnersLoadedEvent(
              partners: _partners,
              branchs: _allBranchesChip,
              highlightedPartners: _highlightedPartners,
            ));
          }

          if (_partnerService.partnerCompanies.isEmpty) {
            add(ErrorEvent("Nenhum parceiro encontrado!"));
          }
        }
      },
    );

    if (_partnerService.hasLoaded) {
      if (_partnerService.partnerCompanies.isNotEmpty) {
        add(PartnersLoadedEvent(
          partners: _partners,
          branchs: _allBranchesChip,
          highlightedPartners: _highlightedPartners,
        ));
      } else {
        add(ErrorEvent("Nenhum parceiro encontrado!"));
      }
    } else {
      add(PartnersLoadingEvent());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
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

  List<BranchModel> get _allBranchesChip {
    return _branchsService.branchs
        .toList()
      ..sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
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
        branchs: event.branchs,
        highlightedPartners: event.highlightedPartners,
      ),
    );
  }

  void _handleSearchFromTitle(
      PartnersSearchEvent event, Emitter<PartnersState> emit) async {
    emit(PartnersLoadingState());

    final List<List<PartnerCompanyModel>> tempPartners = [];
    try {
      final String normalizedSearchTerm =
          removeDiacritics(event.searchTerm.toLowerCase());

      final List<String> branchesId = _branchsService.branchs
          .where((branch) => removeDiacritics(branch.name.toLowerCase())
              .contains(normalizedSearchTerm))
          .map((e) => e.id)
          .toList();

      for (var element in _partners) {
        final List<PartnerCompanyModel> temp = element
            .where((element) =>
                branchesId.contains(element.branchesId.first) ||
                removeDiacritics(element.name.toLowerCase())
                    .contains(normalizedSearchTerm) ||
                (element.fullAddress != null &&
                    removeDiacritics(element.fullAddress!.toLowerCase())
                        .contains(normalizedSearchTerm)))
            .toList();
        if (temp.isNotEmpty) {
          tempPartners.add(temp);
        }
      }
    } catch (ex) {
      rethrow;
    }

    emit(PartnersSearchedState(
      partners: tempPartners,
      branchs: tempPartners.isEmpty ? [] : _allBranchesChip,
      highlightedPartners: const [],
    ));
  }

  void _handleRestartPartners(
      RestartPartnersEvent event, Emitter<PartnersState> emit) {
    emit(PartnersLoadedState(
      partners: _partners,
      branchs: _allBranchesChip,
      highlightedPartners: _highlightedPartners,
    ));
  }

  void _handleSelectPartner(
      SelectPartnerEvent event, Emitter<PartnersState> emit) {
    _partnerService.selectPartner(event.partner);
  }
}
