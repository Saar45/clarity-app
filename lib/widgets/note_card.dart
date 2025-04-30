import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/theme.dart';
import '../services/user_service.dart'; // Import UserService

class NoteCard extends StatelessWidget {
  final Note note;
  final Function onTap;
  final Function onDelete;
  
  const NoteCard({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a color based on the note title
    final colorSeed = note.title.hashCode % 5;
    final List<Color> cardColors = [
      primaryColor.withOpacity(0.8),
      accentColor.withOpacity(0.8),
      secondaryColor.withOpacity(0.8),
      Colors.blue.withOpacity(0.8),
      Colors.amber.withOpacity(0.8),
    ];
    
    // Check if the note is owned by the current user
    final currentUser = UserService.currentUser;
    final isMyNote = currentUser != null && note.userId == currentUser.id;
    
    // Handle potential null values in userId
    String ownerName = "quelqu'un";
    try {
      final ownerUser = UserService.getUserByEmail(note.userId);
      if (ownerUser != null && ownerUser.name.isNotEmpty) {
        ownerName = ownerUser.name;
      } else {
        ownerName = note.userId.split('@').first; // Use the first part of the email if available
      }
    } catch (e) {
      print('Error getting owner name: $e');
    }
    
    final sharedIcon = isMyNote ? Icons.share : Icons.people;
    final sharedTooltip = isMyNote ? 'Partagé avec d\'autres' : 'Partagé avec vous';
    
    return Dismissible(
      key: Key(note.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Supprimer la note'),
              content: Text('Êtes-vous sûr de vouloir supprimer cette note ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('ANNULER'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('SUPPRIMER'),
                ),
              ],
            );
          },
        );
      },
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardColors[colorSeed],
                cardColors[colorSeed].withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cardColors[colorSeed].withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.sharedWith.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Tooltip(
                          message: sharedTooltip,
                          child: Icon(
                            sharedIcon,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    if (!isMyNote)
                      Container(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Tooltip(
                          message: 'Créé par $ownerName',
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  note.content.length > 100
                      ? '${note.content.substring(0, 100)}...'
                      : note.content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withOpacity(0.7),
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(note.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'janv.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
