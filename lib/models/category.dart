class Category {
  final String? id;
  final String name;
  final String? displayName; // الاسم المعروض للمستخدم (اختياري)
  final String imageUrl;
  final int order;
  final bool isActive;

  const Category({
    this.id,
    required this.name,
    this.displayName,
    required this.imageUrl,
    this.order = 0,
    this.isActive = true,
  });

  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'] ?? '',
      displayName: data['displayName'],
      imageUrl: data['imageUrl'] ?? data['image'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'order': order,
      'isActive': isActive,
    };
  }
}
