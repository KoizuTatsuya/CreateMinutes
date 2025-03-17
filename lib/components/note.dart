class Note {
  final int? id;
  final String title;
  final String content;
  final String dateCreate;
  final String dateUpdate;
  final int labelId;
  final String pathSaved;
  final bool flagPin;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateCreate,
    required this.dateUpdate,
    required this.labelId,
    required this.pathSaved,
    required this.flagPin,
  });

  // データベースからNoteオブジェクトを作成するためのメソッド
  factory Note.fromMap(Map<String, dynamic> json) => Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      dateCreate: json['date_create'],
      dateUpdate: json['date_update'],
      labelId: json['label_id'],
      pathSaved: json['path_saved'],
      flagPin: json['flag_pin'] == 0);

  // NoteオブジェクトをMapに変換するためのメソッド
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'date_create': dateCreate,
        'date_update': dateUpdate,
        'label_id': labelId,
        'path_saved': pathSaved,
        'flag_pin': flagPin ? 1 : 0,
      };
}
