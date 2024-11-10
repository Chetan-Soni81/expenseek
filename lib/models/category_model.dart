class CategoryModel {
  int? _id;
  String _categoryName = "";
  String? _color;
  DateTime _createdAt = DateTime.now();

   int? get id => _id;
   String get categoryName => _categoryName;
   String? get color => _color;
   DateTime get createdAt => _createdAt;

  CategoryModel.fromJson(dynamic json) {
    _id = json["id"];
    _categoryName = json["categoryName"];
    _color = json["color"];
    _createdAt = DateTime.parse(json["createdAt"]);
  }

  CategoryModel({required int id, required String name}){
    _id = id; _categoryName = name;
  }

   Map<String, dynamic> toJson(){
    return {
      "id":id,
      "categoryName": categoryName,
      "color": color,
      "createdAt": createdAt,
    };
   }
}