import 'dart:async';
import 'dart:io';
import 'package:app_vida_longa/core/repositories/signatures_repository.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/signature_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SignaturesService {
  SignaturesService._internal();

  static final SignaturesService _instance = SignaturesService._internal();
  static SignaturesService get instance => _instance;

  final ISignaturesRepository _signatureRepository = SignaturesRepositoryImpl(
    FirebaseFirestore.instance,
  );

  @override
  Future<ResponseStatusModel> addSignature(String couponId) async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    final SignatureModel newSignature = SignatureModel.newSignature(
      couponId: couponId,
      lastPaymentDate: formatter.format(now),
      lastPlatform: Platform.isAndroid ? 'google_play' : 'app_store',
      userId: UserService.instance.user.id,
    );

    final response = await _signatureRepository.setSignature(newSignature);

    return response;
  }
}
