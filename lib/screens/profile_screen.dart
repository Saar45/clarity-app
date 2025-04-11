import 'package:flutter/material.dart';
import '../widgets/brain_logo.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(Brightness) changeTheme;

  const ProfileScreen({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      'CP',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Utilisateur',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'utilisateur@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Compte Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildStatCard(context),
                  SizedBox(height: 20),
                  _buildSettingsSection(context, brightness),
                  SizedBox(height: 20),
                  _buildAboutSection(context),
                  SizedBox(height: 30),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Déconnexion'),
                            content: Text('Êtes-vous sûr de vouloir vous déconnecter?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('ANNULER'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                        changeTheme: changeTheme,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('DÉCONNEXION'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Déconnexion', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrainLogo(size: 30, animate: false),
                      SizedBox(width: 8),
                      Text(
                        'CLARITY POINT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, '12', 'Notes'),
            Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3)),
            _buildStatItem(context, '5', 'Partagées'),
            Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.3)),
            _buildStatItem(context, '3', 'Collaborateurs'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, Brightness brightness) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paramètres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Modifier le profil'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fonctionnalité à venir')),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                brightness == Brightness.dark
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_outlined,
              ),
              title: Text('Thème sombre'),
              trailing: Switch(
                value: brightness == Brightness.dark,
                onChanged: (value) {
                  changeTheme(
                    value ? Brightness.dark : Brightness.light,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'À propos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Aide et Support'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Politique de confidentialité'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Conditions d\'utilisation'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
