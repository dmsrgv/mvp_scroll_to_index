class ChipData {
  final String name;
  final int id;
  final String? count;
  final List<Product> products;

  const ChipData({
    required this.name,
    required this.id,
    this.products = const [],
    this.count,
  });

  ChipData copyWith({
    String? name,
    String? count,
    int? id,
    bool? isSelected,
    List<Product>? products,
  }) =>
      ChipData(
        name: name ?? this.name,
        count: count ?? this.count,
        id: id ?? this.id,
        products: products ?? this.products,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChipData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          count == other.count &&
          products == other.products &&
          id == other.id;

  @override
  int get hashCode =>
      name.hashCode ^ count.hashCode ^ id.hashCode ^ products.hashCode;
}

class Product {
  final String name;
  final int? categoryId;

  const Product({required this.name, this.categoryId});
}

final List<Product> products = [
  ...List.generate(
    12,
    (index) => Product(name: 'Вафли $index', categoryId: 0),
  ),
  ...List.generate(
    48,
    (index) => Product(name: 'Самокаты $index', categoryId: 1),
  ),
  ...List.generate(
    13,
    (index) => Product(name: 'Мотоциклы $index', categoryId: 2),
  ),
  ...List.generate(
    17,
    (index) => Product(name: 'Скутеры $index', categoryId: 3),
  ),
];
