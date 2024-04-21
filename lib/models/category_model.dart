class CategoryModel {
  int _id = 0;
  String _categoryName = "";

  int get id => _id;
  String get categoryName => _categoryName;

  CategoryModel.fromJson(dynamic json) {
    _id = json['id'];
    _categoryName = json['categoryName'];
  }
}
