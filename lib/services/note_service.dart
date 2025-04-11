import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService {
  static const String NOTES_KEY = 'user_notes';
  
  // Get all notes
  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(NOTES_KEY) ?? [];
    
    return notesJson
        .map((noteStr) => Note.fromMap(jsonDecode(noteStr)))
        .toList();
  }
  
  // Save a new note
  static Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await _saveNotes(notes);
  }
  
  // Update an existing note
  static Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    
    if (index >= 0) {
      notes[index] = updatedNote;
      await _saveNotes(notes);
    }
  }
  
  // Delete a note
  static Future<void> deleteNote(String noteId) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == noteId);
    await _saveNotes(notes);
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
  
  // Helper method to save notes to shared preferences
  static Future<void> _saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes
        .map((note) => jsonEncode(note.toMap()))
        .toList();
    
    await prefs.setStringList(NOTES_KEY, notesJson);
  }
}
