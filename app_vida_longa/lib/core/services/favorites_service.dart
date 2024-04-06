import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/repositories/favorites_repository.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';

abstract class IFavoritesService {
  late IFavoritesRepository _repository;
  Future<void> init(IFavoritesRepository repository, String userId);
  Future<void> add(String articleId);
  Future<void> remove(String articleId);
  List<ArticleModel> favorites = [];
  late List<String> favoritesIds = [];
  // ignore: unused_element
  set _setIds(List<String> ids);

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
  }

  @override
  Future<void> add(String articleId) async {
    ResponseStatusModel response = ResponseStatusModel();

    List<String> tempIds = favoritesIds;
    tempIds.add(articleId);

    response = await _repository.add(tempIds, userId);

    if (response.status == ResponseStatusEnum.success) {
      favoritesIds.add(articleId);
      favorites.add(_articleService.articles
          .firstWhere((element) => element.uuid == articleId));
    } else {
      AppHelper.displayAlertError("Erro ao adicionar artigo aos favoritos!");
    }
  }

  @override
  Future<void> remove(String articleId) async {
    ResponseStatusModel response = ResponseStatusModel();

    List<String> tempIds = favoritesIds;
    tempIds.add(articleId);
    tempIds.remove(articleId);

    response = await _repository.remove(tempIds, userId);

    if (response.status == ResponseStatusEnum.success) {
      favoritesIds.remove(articleId);
      favorites.removeWhere((element) => element.uuid == articleId);
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
