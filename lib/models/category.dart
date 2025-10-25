class Category {
  final int categoryId;
  final String name;
  final String description;

  Category({
    required this.categoryId,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description'],
    );
  }
}