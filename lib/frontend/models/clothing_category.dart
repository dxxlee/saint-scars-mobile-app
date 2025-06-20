class ClothingCategory {
  final String imageUrl;
  final String title;
  final String description;
  // Дополнительное текстовое поле (например, для подробностей)
  final String text;

  ClothingCategory({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.text,
  });
}
