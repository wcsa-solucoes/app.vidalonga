import 'dart:async';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/repositories/favorites_repository.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';

abstract class IFavoritesService {
  late IFavoritesRepository _repository;
  Future<void> init(IFavoritesRepository repository, String userId);
  Future<void> add(String articleId);
  Future<void> remove(String articleId);
  List<BriefArticleModel> favorites = [];
  late List<String> favoritesIds = [];
  // ignore: unused_element
  set _setIds(List<String> ids);

  Stream<List<BriefArticleModel>> get favoritesStream;

  // ignore: prefer_final_fields
  bool _hasInit = false;
  bool get hasInit => _hasInit;
  // ignore: prefer_final_fields
  String _userId = '';
  String get userId => _userId;
}

class FavoritesServiceImpl extends IFavoritesService {
  FavoritesServiceImpl._internal();
  static final FavoritesServiceImpl _instance =
      FavoritesServiceImpl._internal();
  static FavoritesServiceImpl get instance => _instance;

  final ArticleService _articleService = ArticleService.instance;

  @override
  Stream<List<BriefArticleModel>> get favoritesStream =>
      _favoritesStreamController.stream;

  final StreamController<List<BriefArticleModel>> _favoritesStreamController =
      StreamController.broadcast();

  @override
  Future<void> init(IFavoritesRepository repository, String userId) async {
    if (hasInit) {
      return;
    }
    _hasInit = true;

    _repository = repository;
    _userId = userId;

    final ({List<String> ids, ResponseStatusModel response}) result =
        await repository.getAll(userId);

    if (result.response.status == ResponseStatusEnum.success) {
      _setIds = result.ids;
    } else {
      return;
    }

    for (final article in _articleService.articles) {
      if (favoritesIds.contains(article.uuid)) {
        favorites.add(article);
      }
    }

    _setArticleIds(favorites);
  }

  @override
  Future<void> add(String articleId) async {
    ResponseStatusModel response = ResponseStatusModel();

    List<String> tempIds = favoritesIds.toSet().toList();
    if (!tempIds.contains(articleId)) {
      tempIds.add(articleId);
    }

    response = await _repository.add(tempIds, userId);

    if (response.status == ResponseStatusEnum.success) {
      final BriefArticleModel article = _articleService.articles
          .firstWhere((element) => element.uuid == articleId);

      if (!favoritesIds.contains(articleId)) {
        favoritesIds.add(articleId);
        favorites.add(article);
      }

      _setArticleIds(favorites);
    } else {
      AppHelper.displayAlertError("Erro ao adicionar artigo aos favoritos!");
    }
  }

  void _setArticleIds(List<BriefArticleModel> favoritesArticles) {
    _favoritesStreamController.add(favoritesArticles);
  }

  @override
  Future<void> remove(String articleId) async {
    ResponseStatusModel response = ResponseStatusModel();

    List<String> tempIds = favoritesIds.toSet().toList();
    tempIds.removeWhere((element) => element == articleId);

    response = await _repository.remove(tempIds, userId);

    if (response.status == ResponseStatusEnum.success) {
      favorites.removeWhere((element) => element.uuid == articleId);
      favoritesIds.removeWhere((element) => element == articleId);
      _setArticleIds(favorites);
    } else {
      AppHelper.displayAlertError("Erro ao remover artigo dos favoritos!");
    }
  }

  @override
  set _setIds(List<String> ids) {
    favoritesIds.clear();
    favoritesIds.addAll(ids);
  }

  @override
  bool get hasInit => _hasInit;

  void onLogout() {
    _hasInit = false;
    _userId = '';
    favorites.clear();
    favoritesIds.clear();
  }
}
