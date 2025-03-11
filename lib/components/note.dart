class Note {
  final int? id;
  final String title;
  final String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // データベースからNoteオブジェクトを作成するためのメソッド
  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
      );

  // NoteオブジェクトをMapに変換するためのメソッド
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
      };
}
