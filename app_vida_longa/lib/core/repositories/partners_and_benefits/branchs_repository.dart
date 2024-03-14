import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/branch_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBranchsRepository {
  Future<({List<BranchModel> branchs, ResponseStatusModel response})>
      getAllBranchs();
}

class BranchsRepositoryImpl extends IBranchsRepository {
  FirebaseFirestore firestore;
  BranchsRepositoryImpl({required this.firestore});

  @override
  Future<({List<BranchModel> branchs, ResponseStatusModel response})>
      getAllBranchs() async {
    ResponseStatusModel response = ResponseStatusModel();
    List<BranchModel> branchs = [];

    await firestore.collection(_branches).get().then((value) {
      if (value.docs.isNotEmpty) {
        branchs = value.docs
            .map((e) => BranchModel.fromMap(
                  e.data(),
                ))
            .toList();
        response.status = ResponseStatusEnum.success;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
      response.message = "Erro ao buscar as filiais.";
    });

    return (response: response, branchs: branchs);
  }
}

const _branches = 'branches';
