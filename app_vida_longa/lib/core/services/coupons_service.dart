import 'dart:async';
import 'package:app_vida_longa/core/repositories/coupons_repository.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ICouponsService {
  Future<void> init();
  List<CouponModel> get coupons;

  Stream<List<CouponModel>> get couponsStream;
  Future<ResponseStatusModel> incrementUsageQuantityOfCoupon(
      CouponModel coupon);
}

class CouponsServiceImpl implements ICouponsService {
  CouponsServiceImpl._internal();

  static final CouponsServiceImpl _instance = CouponsServiceImpl._internal();

  static CouponsServiceImpl get instance => _instance;

  final ICouponsRepository _couponsRepository = CouponsRepositoryImpl(
    FirebaseFirestore.instance,
  );

  late final StreamSubscription<List<CouponModel>> subscription;

  final List<CouponModel> _coupons = [];

  bool _hasInit = false;

  @override
  Future<void> init() async {
    if (_hasInit) {
      return;
    }
    _hasInit = true;
    final (:response, :coupons) = await _couponsRepository.getCoupons();

    if (response.status == ResponseStatusEnum.success) {
      _setCoupons(coupons);
    }

    _couponsRepository.couponsListener();

    subscription = couponsStream.listen((List<CouponModel> event) {
      _setCoupons(event);
    });
  }

  void _setCoupons(List<CouponModel> coupons) {
    _coupons.clear();
    _coupons.addAll(coupons);
  }

  @override
  List<CouponModel> get coupons => _coupons;

  @override
  Stream<List<CouponModel>> get couponsStream =>
      _couponsRepository.couponsStream;

  @override
  Future<ResponseStatusModel> incrementUsageQuantityOfCoupon(
      CouponModel coupon) async {
    final res = await _couponsRepository.incrementCouponUsageQuantity(coupon);
    return res;
  }
}
