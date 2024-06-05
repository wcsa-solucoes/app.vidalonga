import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICategoriesRepository {
  Future<({ResponseStatusModel response, List<CategoryModel> categories})>
      getAll();
}

class CategoriesRepository extends ICategoriesRepository {
  late final FirebaseFirestore firestore;

  CategoriesRepository({required this.firestore});

  @override
  Future<({ResponseStatusModel response, List<CategoryModel> categories})>
      getAll() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<CategoryModel> categories = [];

    await firestore.collection('categories').get().then((value) {
      for (var element in value.docs) {
        categories.add(CategoryModel.fromMap(element.data()));
      }
    }).catchError((onError) {
      response.message = onError.toString();
      response.status = ResponseStatusEnum.error;
    });

    return (response: response, categories: categories);
  }

  //
}
