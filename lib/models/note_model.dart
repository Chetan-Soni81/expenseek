class NoteModel {
  int? _id;
  String? _title;
  String? _description;
  DateTime _createdDate = DateTime.now();

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  DateTime get createdDate => _createdDate;
}