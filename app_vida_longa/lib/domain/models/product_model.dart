enum ProductType { product, subscription }

class ProductModel {
  final String title;
  final double price;
  final String productId;
  final ProductType productType;

  ProductModel({
    required this.title,
    required this.price,
    required this.productId,
    required this.productType,
  });
}
