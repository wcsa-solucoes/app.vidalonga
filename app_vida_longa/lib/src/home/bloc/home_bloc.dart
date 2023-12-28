import 'dart:async';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadedEvent>(_handleLoaded);
    on<HomeLoadingEvent>(_handleLoading);
    on<HomeCategoriesSelectedEvent>(_handleCategoriesSelected);
    if (_articles.isNotEmpty) {
      _allChips = _articles
          .map<ChipCategorie>((List<ArticleModel> e) => ChipCategorie(
                label: e.first.category,
                selected: false,
              ))
          .toList();
      add(HomeLoadedEvent(articles: _articles, chipsCategorie: _allChips));
    }
  }
  FutureOr<void> _handleCategoriesSelected(
      HomeCategoriesSelectedEvent event, Emitter<HomeState> emit) {
    emit(HomeCategoriesSelectedState(
      articlesByCategorySelected: event.articles,
      chipsCategorie: event.chipsCategorie,
      articlesByCategory: _articles,
    ));
  }

  FutureOr<void> _handleLoading(
      HomeLoadingEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());
  }

  FutureOr<void> _handleLoaded(HomeLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(
      articlesByCategory: _articles,
      chipsCategorie: _allChips,
    ));
  }

  final ArticleService _articleService = ArticleService.instance;

  List<List<ArticleModel>> get _articles => _articleService.articles
          .fold<List<List<ArticleModel>>>(<List<ArticleModel>>[],
              (previousValue, element) {
        if (previousValue.isEmpty) {
          previousValue.add(<ArticleModel>[element]);
        } else {
          final List<ArticleModel> lastList = previousValue.last;
          if (lastList.first.category == element.category) {
            lastList.add(element);
          } else {
            previousValue.add(<ArticleModel>[element]);
          }
        }
        return previousValue;
      });
//get all chips from  articles with selected false
  late List<ChipCategorie> _allChips;
}
