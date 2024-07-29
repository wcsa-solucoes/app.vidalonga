import 'dart:async';

import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/signature_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ISignaturesRepository {
  Future<ResponseStatusModel> setSignature(SignatureModel signature);
}

class SignaturesRepositoryImpl implements ISignaturesRepository {
  FirebaseFirestore firestore;
  SignaturesRepositoryImpl(
    this.firestore,
  );

  @override
  Future<ResponseStatusModel> setSignature(SignatureModel signature) async {
    final ResponseStatusModel response = ResponseStatusModel();
    var newDoc = firestore.collection('signatures').doc(signature.userId);

    await newDoc
        .set(signature.newSignatureToMap(signature.userId))
        .then((value) => null)
        .onError(
      (Object? object, StackTrace error) {
        response.status = ResponseStatusEnum.error;
        response.message = 'Erro ao adicionar a assinatura';
      },
    );

    return response;
  }
}
