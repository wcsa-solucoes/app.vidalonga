import 'dart:async';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/utils/string_util.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';
import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ArticleService _articleService = ArticleService.instance;

  late final StreamSubscription<(List<BriefArticleModel>, List<CategoryModel>)>
      _subscription;
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadedEvent>(_handleLoaded);
    on<HomeLoadingEvent>(_handleLoading);
    on<HomeCategoriesSelectedEvent>(_handleCategoriesSelected);
    on<HomeSearchEvent>(_handleSearchFromTitle);
    on<RestartHomeEvent>(_handleRestartHome);

    _subscription = _articleService.articlesStream.listen((event) {
      if (event.$1.isEmpty || event.$2.isEmpty) {
        return;
      }

      add(HomeLoadedEvent(
          articles: _articles, chipsCategorie: _allCategoriesChips));
    });

    if (_articleService.articles.isNotEmpty) {
      add(HomeLoadedEvent(
          articles: _articles, chipsCategorie: _allCategoriesChips));
    }
  }

  FutureOr<void> _handleLoading(
      HomeLoadingEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());
  }

  FutureOr<void> _handleLoaded(HomeLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(
      articlesByCategory: _articles,
      chipsCategorie: _allCategoriesChips,
    ));
  }

  _handleRestartHome(RestartHomeEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(
        articlesByCategory: _articles, chipsCategorie: _allCategoriesChips));
  }

  Future<void> _handleSearchFromTitle(
      HomeSearchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    final List<List<BriefArticleModel>> tempArticles = [];

    for (var element in _articles) {
      final String normalizedSearchTerm = removeDiacritics(event.searchTerm);
      final List<BriefArticleModel> temp = element.where((element) {
        final String normalizedTitle = removeDiacritics(element.title);
        return normalizedTitle.toLowerCase().contains(normalizedSearchTerm);
      }).toList();

      if (temp.isNotEmpty) {
        tempArticles.add(temp);
      }
    }

    emit(
      ArticlesSearchedState(
        articlesByCategory: tempArticles,
        chipsCategorie: _allCategoriesChips,
      ),
    );
  }

  FutureOr<void> _handleCategoriesSelected(
      HomeCategoriesSelectedEvent event, Emitter<HomeState> emit) {
    emit(HomeCategoriesSelectedState(
      articlesByCategorySelected: event.articles,
      chipsCategorie: event.chipsCategorie,
      articlesByCategory: _articles,
    ));
  }

  List<List<BriefArticleModel>> get _articles => _articleService.articles
          .fold<List<List<BriefArticleModel>>>(<List<BriefArticleModel>>[],
              (previousValue, element) {
        final List<BriefArticleModel>? foundList = previousValue.firstWhereOrNull(
          (list) => list.first.categoryUuid == element.categoryUuid,
        );

        if (foundList != null) {
          foundList.add(element);
        } else {
          previousValue.add(<BriefArticleModel>[element]);
        }
        return previousValue;
      });

  List<ChipCategorieModel> get _allCategoriesChips {
    return _articleService.categories
        .map(
          (e) => ChipCategorieModel(
            label: e.name,
            selected: false,
            uuid: e.uuid,
          ),
        )
        .toList();
  }
}
