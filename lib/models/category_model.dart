class CategoryModel {
  int? _id;
  String _categoryName = "";
  String? _color;
  DateTime _createdAt = DateTime.now();

   int? get id => _id;
   String get categoryName => _categoryName;
   String? get color => _color;
   DateTime get createdAt => _createdAt;
}