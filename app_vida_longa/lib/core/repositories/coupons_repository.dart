import 'dart:async';

import 'package:app_vida_longa/core/helpers/date_time_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICouponsRepository {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      subscription;
  Future<({ResponseStatusModel response, List<CouponModel> coupons})>
      getCoupons();
  Future<ResponseStatusModel> incrementCouponUsageQuantity(CouponModel coupon);

  Stream<List<CouponModel>> get couponsStream;

  List<CouponModel> get coupons;

  void couponsListener();

  void cancelListener();
}

class CouponsRepositoryImpl implements ICouponsRepository {
  FirebaseFirestore firestore;
  CouponsRepositoryImpl(
    this.firestore,
  );

  bool _hasListener = false;

  final StreamController<List<CouponModel>> _couponsStreamController =
      StreamController<List<CouponModel>>.broadcast();

  @override
  Stream<List<CouponModel>> get couponsStream =>
      _couponsStreamController.stream;

  @override
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      subscription;

  @override
  List<CouponModel> get coupons => _coupons;

  final List<CouponModel> _coupons = [];

  @override
  Future<({ResponseStatusModel response, List<CouponModel> coupons})>
      getCoupons() async {
    ResponseStatusModel response = ResponseStatusModel();

    await firestore.collection('coupons').get().then((querySnapshot) {
      final List<CouponModel> tempCoupons = [];

      for (var doc in querySnapshot.docs) {
        tempCoupons.add(CouponModel.fromMap(doc.data()));
      }
      _setCoupons(tempCoupons);
    }).catchError((error) {
      response.status = ResponseStatusEnum.error;
      response.message = error.toString();
    });

    return (response: response, coupons: coupons);
  }

  void _setCoupons(List<CouponModel> coupons) {
    _coupons.clear();
    _coupons.addAll(coupons);
    _couponsStreamController.add(_coupons);
  }

  @override
  Future<ResponseStatusModel> incrementCouponUsageQuantity(
      CouponModel coupon) async {
    ResponseStatusModel response = ResponseStatusModel();

    await firestore.collection('coupons').doc(coupon.uuid).update({
      'usageQuantity': FieldValue.increment(1),
      "usageHistory": FieldValue.arrayUnion([
        {
          "date": DateTimeHelper.formatEpochTimestamp(
              DateTime.now().millisecondsSinceEpoch),
          "userId": UserService.instance.user.id,
        }
      ])
    }).then((value) {
      response.status = ResponseStatusEnum.success;
    }).onError(
      (obj, error) {
        PrintColoredHelper.printError('>>>>>>>>>>>>Error ${error.toString()}');

        response.status = ResponseStatusEnum.error;
        response.message = error.toString();
      },
    );

    return response;
  }

  @override
  void cancelListener() {
    if (_hasListener) {
      subscription?.cancel();
      _hasListener = false;
    }
  }

  @override
  void couponsListener() {
    if (!_hasListener) {
      subscription = firestore
          .collection('coupons')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> event) {
        final List<CouponModel> tempCoupons = [];

        for (var doc in event.docs) {
          tempCoupons.add(CouponModel.fromMap(doc.data()));
        }
        _setCoupons(tempCoupons);
      });

      _hasListener = true;
    }
  }
}
