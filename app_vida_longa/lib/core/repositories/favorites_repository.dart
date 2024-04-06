import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IFavoritesRepository<T> {
  late T dataSource;
  Future<ResponseStatusModel> add(List<String> ids, String userId);
  Future<ResponseStatusModel> remove(List<String> ids, String userId);
  Future<({ResponseStatusModel response, List<String> ids})> getAll(
      String userId);
}

class FavoritesRepositoryImpl
    implements IFavoritesRepository<FirebaseFirestore> {
  @override
  FirebaseFirestore dataSource;
  FavoritesRepositoryImpl(this.dataSource);

  @override
  Future<ResponseStatusModel> add(List<String> ids, String userId) async {
    ResponseStatusModel response = ResponseStatusModel();

    await dataSource
        .collection('favoritesArticles')
        .doc(userId)
        .set({'articles': ids})
        .then((value) => null)
        .onError((error, stackTrace) {
          response = WeException.handle(error);
        });

    return response;
  }

  @override
  Future<ResponseStatusModel> remove(List<String> ids, String userId) async {
    ResponseStatusModel response = ResponseStatusModel();
    await dataSource
        .collection('favoritesArticles')
        .doc(userId)
        .set({'articles': ids})
        .then((value) => null)
        .onError((error, stackTrace) {
          response = WeException.handle(error);
        });
    return response;
  }

  @override
  Future<({ResponseStatusModel response, List<String> ids})> getAll(
      String userId) async {
    ResponseStatusModel response = ResponseStatusModel();
    List<String> ids = [];

    await dataSource
        .collection('favoritesArticles')
        .doc(userId)
        .get()
        .then((value) {
      if (value.exists) {
        ids = List<String>.from(value.data()!['articles']);
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return (response: response, ids: ids);
  }
}
