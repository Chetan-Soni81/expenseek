import 'package:expenseek/models/base_model.dart';

class NoteModel extends BaseModel {
  String? _title;
  String? _description;

  String? get title => _title;
  String? get description => _description;

  NoteModel.fromJson(dynamic json) : super.fromJson(json) {
    _title = json['title'];
    _description = json['description'];
  }
}