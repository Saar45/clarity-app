class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> sharedWith;
  String userId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    List<String>? sharedWith, // Make this optional
    required this.userId,
  }) : this.sharedWith = sharedWith ?? []; // Initialize as empty modifiable list if null

  // Factory constructor to create a new note
  factory Note.create({required String title, required String content, required String userId}) {
    return Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: userId,
      sharedWith: [], // Explicitly provide an empty modifiable list
    );
  }

  // Factory constructor to convert from Map (for storage)
  factory Note.fromMap(Map<String, dynamic> map) {
    List<String> sharedWithList = [];
    
    // Safely handle the sharedWith list
    if (map['sharedWith'] != null) {
      if (map['sharedWith'] is List) {
        sharedWithList = List<String>.from(map['sharedWith']);
      }
    }
    
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      sharedWith: sharedWithList, // Use the safely created list
      userId: map['userId'] ?? '',
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
      'sharedWith': List<String>.from(sharedWith), // Make a copy to ensure it's modifiable
      'userId': userId,
    };
  }

  // Update note content
  void updateContent({String? newTitle, String? newContent}) {
    if (newTitle != null) title = newTitle;
    if (newContent != null) content = newContent;
    updatedAt = DateTime.now();
  }

  // Share note with another user - fixed to handle modifiable list
  void shareWith(String userEmail) {
    // Ensure sharedWith is initialized
    if (sharedWith == null) {
      sharedWith = [];
    }
    
    // Only add if not already in the list
    if (!sharedWith.contains(userEmail)) {
      sharedWith.add(userEmail);
    }
  }
  
  // Remove shared user - added for completeness
  void removeSharedUser(String userEmail) {
    if (sharedWith.contains(userEmail)) {
      sharedWith.remove(userEmail);
    }
  }
}
