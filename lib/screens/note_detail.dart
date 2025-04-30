import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../utils/strings.dart';
import '../services/user_service.dart';
import 'note_editor.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note note;

  @override
  void initState() {
    super.initState();
    note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    final colorSeed = note.title.hashCode % 5;
    final List<Color> headerColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Colors.blue,
      Colors.amber,
    ];
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: headerColors[colorSeed],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                note.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      headerColors[colorSeed],
                      headerColors[colorSeed].withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.8), size: 16),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(note.createdAt),
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: _showShareDialog,
                tooltip: Strings.shareNote,
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final updatedNote = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(note: note),
                    ),
                  );
                  
                  if (updatedNote != null) {
                    setState(() {
                      note = updatedNote;
                    });
                    // Also ensure the note is updated in storage
                    await NoteService.updateNote(note);
                  }
                },
                tooltip: Strings.editNote,
              ),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.white),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: note.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Strings.noteCopied)),
                  );
                },
                tooltip: Strings.copyClipboard,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (note.sharedWith.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.share, 
                            size: 20, 
                            color: Theme.of(context).colorScheme.secondary
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${Strings.sharedWith} ${note.sharedWith.length} ${Strings.users}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, 
                              size: 16, 
                              color: Theme.of(context).colorScheme.primary
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${Strings.created}: ${_formatDate(note.createdAt)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.update, 
                            size: 16, 
                            color: Theme.of(context).colorScheme.primary
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${Strings.updated}: ${_formatDate(note.updatedAt)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      note.content,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'janv.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} à ${_formatTime(date)}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showShareDialog() {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.shareDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: Strings.emailLabel,
                hintText: Strings.emailHint,
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            if (note.sharedWith.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Strings.sharedWithLabel,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: note.sharedWith.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        child: Text(
                          note.sharedWith[index].substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      title: Text(note.sharedWith[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          // Create a new list to avoid modifying the original directly
                          List<String> updatedSharedWith = List.from(note.sharedWith);
                          updatedSharedWith.removeAt(index);
                          
                          setState(() {
                            note.sharedWith = updatedSharedWith;
                          });
                          
                          // Save the updated note
                          NoteService.updateNote(note);
                          Navigator.pop(context);
                          _showShareDialog();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Strings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                final email = emailController.text.trim();
                
                try {
                  // Create a new modifiable list with the existing shared emails
                  final updatedSharedWith = List<String>.from(note.sharedWith);
                  
                  // Add the new email if not already present
                  if (!updatedSharedWith.contains(email)) {
                    updatedSharedWith.add(email);
                  }
                  
                  // Update the note's sharedWith list
                  setState(() {
                    note.sharedWith = updatedSharedWith;
                  });
                  
                  // Save the updated note
                  await NoteService.updateNote(note);
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${Strings.noteSharedWith} ${email}')),
                  );
                } catch (e) {
                  print('Error while sharing note: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors du partage de la note: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(Strings.share),
          ),
        ],
      ),
    );
  }
}
