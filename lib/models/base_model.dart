class BaseModel {
  int? _id;
  DateTime _createdAt = DateTime.now();

  int? get id => _id;
  DateTime get createdAt => _createdAt;

  BaseModel.fromJson(dynamic json)
  {
    _id = json["id"];
    _createdAt = DateTime.parse(json["createdAt"]);
  }

  BaseModel({required int? id}) {
    _id = id;
  }
}