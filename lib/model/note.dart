const String tableNotes = "notes";

class NoteFields {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String descriptipn;
  final DateTime createdTime;
  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.descriptipn,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.isImportant: isImportant ==true? 1 : 0,
        NoteFields.description: descriptipn,
        NoteFields.number: number,
        NoteFields.time: createdTime.toIso8601String(),
        NoteFields.title: title
      };
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        descriptipn: json[NoteFields.description] as String,
        isImportant: json[NoteFields.isImportant]  ==1? true:false,
        createdTime: DateTime.parse(json[NoteFields.time] as String) ,


      );
  Note copy(
          {int? id,
          bool? isImportant,
          int? number,
          String? title,
          String? descriptipn,
          DateTime? createdTime}) =>
      Note(
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          descriptipn: descriptipn ?? this.descriptipn,
          createdTime: createdTime ?? this.createdTime);
}
