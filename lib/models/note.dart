class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> sharedWith;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.sharedWith = const [],
  });

  // Factory constructor to create a new note
  factory Note.create({required String title, required String content}) {
    return Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Factory constructor to convert from Map (for storage)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
    );
  }

  // Convert to Map (for storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sharedWith': sharedWith,
    };
  }

  // Update note content
  void updateContent({String? newTitle, String? newContent}) {
    if (newTitle != null) title = newTitle;
    if (newContent != null) content = newContent;
    updatedAt = DateTime.now();
  }

  // Share note with another user
  void shareWith(String userId) {
    if (!sharedWith.contains(userId)) {
      sharedWith.add(userId);
    }
  }
}
