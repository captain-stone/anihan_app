class Product {
  final String name;
  final String imagePath;
  final double price;
  final double? rating;
  final int? itemsSold;

  Product(
      {required this.name,
      required this.imagePath,
      required this.price,
      this.rating,
      this.itemsSold});
}
