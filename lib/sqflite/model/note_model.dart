import 'dart:convert';

const String tableNote = "notes";

class NoteFields {
  static List<String> values = [
    id,
    number,
    title,
    description,
    isImportant,
    time
  ];
  static const String id = "_id";
  static const String number = "number";
  static const String title = "title";
  static const String description = "description";
  static const String isImportant = "isImportant";
  static const String time = "time";
}

class Note {
  final int? id;
  final int number;
  final String title;
  final String description;
  final bool isImportant;
  final DateTime createTime;

  Note(
      {this.id,
      required this.number,
      required this.title,
      required this.description,
      required this.isImportant,
      required this.createTime});

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createTime: createdTime ?? createTime,
      );

  static Note fromjson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as int?,
      number: json[NoteFields.number] as int,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      isImportant: json[NoteFields.isImportant] == 1,
      createTime: DateTime.parse(json[NoteFields.time] as String));

  Map<String, Object?> tojson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.time: createTime.toIso8601String(),
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.description: description,
        NoteFields.number: number,
      };
}
