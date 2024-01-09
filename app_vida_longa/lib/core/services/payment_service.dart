class PaymentService {
  //apple and google payment
  Future<bool> pay() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
