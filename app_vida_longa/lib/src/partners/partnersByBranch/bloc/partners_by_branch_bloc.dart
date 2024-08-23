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

part 'partners_by_branch_event.dart';
part 'partners_by_branch_state.dart';

class PartnersByBranchBloc
    extends Bloc<PartnersByBranchEvent, PartnersByBranchState> {
  final IPartnerService _partnerService = PartnerServiceImpl.instance;
  final IBranchsService _branchsService = BranchsServiceImpl.instance;

  PartnersByBranchBloc() : super(PartnersByBranchLoadingState()) {
    on<PartnersByBranchLoadingEvent>(_handleLoading);
    on<PartnersByBranchLoadedEvent>(_handleLoaded);
    on<PartnersByBranchSearchEvent>(_handleSearchFromTitle);
    on<PartnersByBranchEmptyEvent>(_handleEmpty);
    on<RestartPartnersByBranchEvent>(_handleRestart);
    on<ErrorEvent>((event, emit) {
      emit(PartnersByBranchErrorState(event.message));
    });

    if (_partnerService.partnersByBranch.isNotEmpty) {
      add(PartnersByBranchLoadedEvent());
    }
    else {
      add(PartnersByBranchEmptyEvent());
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  List<List<PartnerCompanyModel>> get _partners =>
      _partnerService.partnersByBranch.fold<List<List<PartnerCompanyModel>>>(
          <List<PartnerCompanyModel>>[], (previousValue, element) {
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
    final branch = _branchsService.selectedBranch;

    return [branch];
  }

  String getBranchName(String branchId) {
    final branch = _branchsService.branchs
        .firstWhere((BranchModel element) => element.id == branchId);
    return branch.name;
  }

  void _handleLoading(
      PartnersByBranchLoadingEvent event, Emitter<PartnersByBranchState> emit) {
    emit(PartnersByBranchLoadingState());
    final branch = _branchsService.branchs
        .firstWhere((element) => element.id == event.branchId);
    _branchsService.selectBranch(branch);

    _partnerService.setPartnersByBranch(branch);

    add(PartnersByBranchLoadedEvent());
  }

  void _handleLoaded(
      PartnersByBranchLoadedEvent event, Emitter<PartnersByBranchState> emit) {
    emit(
      PartnersByBranchLoadedState(
        partners: _partnerService.partnersByBranch,
        branch: _branchsService.selectedBranch,
      ),
    );
  }

  void _handleRestart(
      RestartPartnersByBranchEvent event, Emitter<PartnersByBranchState> emit) {
    emit(
      PartnersByBranchLoadedState(
        partners: _partnerService.partnersByBranch,
        branch: _branchsService.selectedBranch,
      ),
    );
  }

  void _handleEmpty(PartnersByBranchEmptyEvent event, Emitter<PartnersByBranchState> emit) {
    emit(PartnersByBranchEmptyState());
  }

  void _handleSearchFromTitle(PartnersByBranchSearchEvent event,
      Emitter<PartnersByBranchState> emit) async {
    emit(PartnersByBranchLoadingState());

    final List<PartnerCompanyModel> tempPartners = [];
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
          for (var element in temp) {
            tempPartners.add(element);
          }
        }
      }
    } catch (ex) {
      rethrow;
    }

    emit(PartnersByBranchSearchedState(
      partners: tempPartners,
      branchs: tempPartners.isEmpty ? [] : _allBranchesChip,
      highlightedPartners: const [],
    ));
  }
}
