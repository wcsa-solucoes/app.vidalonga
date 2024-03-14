import 'dart:async';
import 'package:app_vida_longa/core/services/benefits_service.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'benefits_event.dart';
part 'benefits_state.dart';

class BenefitsBloc extends Bloc<BenefitsEvent, BenefitsState> {
  final IBenefitsService _benefitsService = BenefitisServiceImpl.instance;

  BenefitsBloc() : super(BenefitsLoadingState()) {
    on<BenefitsEvent>((event, emit) {});

    on<BenefitsLoadingEvent>(_handleLoading);

    on<BenefitCategorieSelectedEvent>(_handleCategorieSelected);

    on<BenefitsLoadedEvent>(_handleLoaded);
    on<RestartBenefitsEvent>(_handleRestartBenefits);
    on<BenefitsSearchEvent>(_handleSearchFromTitle);

    if (_benefitsService.benefits.isNotEmpty) {
      var test = _benefits;
      var test2 = _allCategoriesChips;

      add(BenefitsLoadedEvent(benefits: test, chipsCategorie: test2));
    } else {
      add(BenefitsLoadingEvent());
    }
  }

  void _handleSearchFromTitle(
      BenefitsSearchEvent event, Emitter<BenefitsState> emit) async {
    emit(BenefitsLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    final List<List<BenefitModel>> tempBenefits = [];
    for (var element in _benefits) {
      final List<BenefitModel> temp = element
          .where((element) => element.title
              .toLowerCase()
              .contains(event.searchTerm.toLowerCase()))
          .toList();
      if (temp.isNotEmpty) {
        tempBenefits.add(temp);
      }
    }
    emit(BenefitsLoadedState(
        benefits: tempBenefits, chipsCategorie: _allCategoriesChips));
  }

  FutureOr<void> _handleLoading(BenefitsLoadingEvent event, emit) {
    emit(BenefitsLoadingState());
  }

  FutureOr<void> _handleRestartBenefits(
      RestartBenefitsEvent event, Emitter<BenefitsState> emit) {
    emit(BenefitsLoadedState(
        benefits: _benefits, chipsCategorie: _allCategoriesChips));
  }

  void _handleCategorieSelected(
      BenefitCategorieSelectedEvent event, Emitter<BenefitsState> emit) {
    emit(HomeCategoriesSelectedState(
      // articlesByCategorySelected: event.articles,
      // chipsCategorie: event.chipsCategorie,
      // articlesByCategory: _articles,
      benefitsByCategorySelected: event.benefits,
      benefitsByCategory: _benefits,
      chipsCategorie: _allCategoriesChips,
    ));
  }

  void _handleLoaded(BenefitsLoadedEvent event, Emitter<BenefitsState> emit) {
    emit(BenefitsLoadedState(
        benefits: event.benefits, chipsCategorie: event.chipsCategorie));
  }

  List<List<BenefitModel>> get _benefits => _benefitsService.benefits
          .fold<List<List<BenefitModel>>>(<List<BenefitModel>>[],
              (previousValue, element) {
        final List<BenefitModel>? foundList = previousValue.firstWhereOrNull(
          (list) => list.first.categoryId == element.categoryId,
        );

        if (foundList != null) {
          foundList.add(element);
        } else {
          previousValue.add(<BenefitModel>[element]);
        }
        return previousValue;
      });

  List<ChipCategorieModel> get _allCategoriesChips {
    return _benefitsService.categories
        .map(
          (e) => ChipCategorieModel(
            label: e.name,
            selected: false,
            uuid: e.id,
          ),
        )
        .toList();
  }
}
