import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../utils/strings.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isEditing = false;
  late Note? _currentNote;
  bool _isDirty = false;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    _currentNote = widget.note;
    
    if (_isEditing) {
      _titleController.text = _currentNote!.title;
      _contentController.text = _currentNote!.content;
    }
    
    _titleController.addListener(_markDirty);
    _contentController.addListener(_markDirty);
    
    // Set focus to title if new note, to content if editing
    Future.delayed(Duration(milliseconds: 200), () {
      if (_isEditing) {
        _contentFocus.requestFocus();
      } else {
        _titleFocus.requestFocus();
      }
    });
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? Strings.editNoteTitle : Strings.newNote),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveNote,
              tooltip: Strings.saveNote,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.05),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _titleController,
                      focusNode: _titleFocus,
                      decoration: InputDecoration(
                        hintText: Strings.titleHint,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _contentController,
                        focusNode: _contentFocus,
                        decoration: InputDecoration(
                          hintText: Strings.contentHint,
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _isDirty ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: _saveNote,
            child: Icon(Icons.save),
            tooltip: Strings.saveNote,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quitter sans enregistrer?'),
        content: Text('Vos modifications seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('ANNULER'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('QUITTER'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.titleRequired)),
      );
      _titleFocus.requestFocus();
      return;
    }
    
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.contentRequired)),
      );
      _contentFocus.requestFocus();
      return;
    }
    
    if (_isEditing) {
      _currentNote!.updateContent(
        newTitle: title,
        newContent: content,
      );
      await NoteService.updateNote(_currentNote!);
      Navigator.pop(context, _currentNote);
    } else {
      final newNote = Note.create(
        title: title,
        content: content,
      );
      await NoteService.addNote(newNote);
      Navigator.pop(context);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEditing ? 'Note mise à jour' : 'Note créée')),
    );
  }
}
