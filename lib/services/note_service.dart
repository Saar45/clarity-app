import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import 'user_service.dart';

class NoteService {
  static const String NOTES_KEY = 'user_notes';
  static List<Note> _notes = [];
  static bool _initialized = false;
  
  // Initialize notes
  static Future<void> initialize() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(NOTES_KEY) ?? [];
    
    _notes = notesJson.map((noteStr) => Note.fromMap(jsonDecode(noteStr))).toList();
    _initialized = true;
  }
  
  // Get all notes for current user
  static Future<List<Note>> getNotes() async {
    await initialize();
    final currentUser = UserService.currentUser;
    
    if (currentUser == null) {
      return [];
    }
    
    // Return user's own notes and notes shared with them
    return _notes.where((note) => 
      note.userId == currentUser.id || 
      note.sharedWith.contains(currentUser.email)
    ).toList();
  }
  
  // Get notes shared with the current user
  static Future<List<Note>> getSharedNotes() async {
    await initialize();
    final currentUser = UserService.currentUser;
    
    if (currentUser == null) {
      return [];
    }
    
    return _notes.where((note) => 
      note.userId != currentUser.id && 
      note.sharedWith.contains(currentUser.email)
    ).toList();
  }
  
  // Get notes created by the current user
  static Future<List<Note>> getMyNotes() async {
    await initialize();
    final currentUser = UserService.currentUser;
    
    if (currentUser == null) {
      return [];
    }
    
    return _notes.where((note) => note.userId == currentUser.id).toList();
  }
  
  // Check if a note is shared with someone
  static bool isShared(Note note) {
    return note.sharedWith.isNotEmpty;
  }
  
  // Count of user's notes
  static Future<int> getNotesCount() async {
    final notes = await getMyNotes();
    return notes.length;
  }
  
  // Count of notes shared by the user
  static Future<int> getSharedByMeCount() async {
    final notes = await getMyNotes();
    return notes.where((note) => note.sharedWith.isNotEmpty).length;
  }
  
  // Count of users the current user has shared with
  static Future<int> getUniqueCollaboratorsCount() async {
    final notes = await getMyNotes();
    final allCollaborators = <String>{};
    
    for (final note in notes) {
      allCollaborators.addAll(note.sharedWith);
    }
    
    return allCollaborators.length;
  }
  
  // Save a new note
  static Future<void> addNote(Note note) async {
    await initialize();
    _notes.add(note);
    await _saveAllNotes();
  }
  
  // Update an existing note
  static Future<void> updateNote(Note updatedNote) async {
    await initialize();
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    
    if (index >= 0) {
      _notes[index] = updatedNote;
      await _saveAllNotes();
    }
  }
  
  // Delete a note
  static Future<void> deleteNote(String noteId) async {
    await initialize();
    _notes.removeWhere((note) => note.id == noteId);
    await _saveAllNotes();
  }
  
  // Get notes sorted by date
  static Future<List<Note>> getNotesSortedByDate({bool descending = true}) async {
    final notes = await getNotes();
    notes.sort((a, b) {
      return descending 
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt);
    });
    return notes;
  }
  
  // Save all notes to SharedPreferences
  static Future<void> _saveAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = _notes
        .map((note) => jsonEncode(note.toMap()))
        .toList();
    
    await prefs.setStringList(NOTES_KEY, notesJson);
  }
}
