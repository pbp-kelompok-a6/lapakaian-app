class Product {
  final int id;
  final String name;
  final String brand;
  final String size;
  final String priceDisplay;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.size,
    required this.priceDisplay,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        name: (j['name'] ?? '') as String,
        brand: (j['brand'] ?? '') as String,
        size: (j['size'] ?? '') as String,
        priceDisplay: (j['price_display'] ?? '') as String,
        imageUrl: (j['image_url'] as String?)?.isEmpty ?? true
            ? null
            : j['image_url'] as String,
      );
}