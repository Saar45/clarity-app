# Clarity Point

![Clarity Point Logo](assets/images/logo.png)

Une application de prise de notes intelligente pour organiser vos pensées.

## Comment exécuter l'application localement sur un simulateur Android

### Prérequis
1. **Flutter SDK** : Assurez-vous d'avoir Flutter SDK installé (version 3.0.0 ou supérieure)
2. **Android Studio** : Avec le plugin Flutter et les outils Android SDK
3. **Simulateur Android** : Configuré via AVD Manager dans Android Studio

### Étapes pour exécuter l'application
1. **Cloner le dépôt** :
   ```bash
   git clone <url-du-repo>
   cd /Users/naby/Developer/clarity-app/clarity
   ```

2. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```

3. **Lancer le simulateur Android** :
   - Ouvrez Android Studio
   - Sélectionnez "AVD Manager" dans le menu "Tools"
   - Démarrez un émulateur existant ou créez-en un nouveau

4. **Vérifier les appareils disponibles** :
   ```bash
   flutter devices
   ```

5. **Exécuter l'application** :
   ```bash
   flutter run
   ```

## Workflow d'interaction entre les utilisateurs

### 1. Inscription et Connexion

**Processus d'inscription :**
1. L'utilisateur accède à l'écran d'inscription depuis l'écran de connexion
2. Il remplit les informations requises (nom, email, mot de passe)
3. Il accepte les conditions d'utilisation
4. Un compte est créé et l'utilisateur est redirigé vers l'écran principal

**Processus de connexion :**
1. L'utilisateur saisit son email et mot de passe
2. Identifiants de démonstration : 
   - Email: `demo@clarity.com` / Mot de passe: `password123`
   - Email: `admin@clarity.com` / Mot de passe: `admin123`

### 2. Gestion des Notes

**Création d'une note :**
1. L'utilisateur clique sur le bouton "+" dans l'écran principal
2. Il saisit un titre et un contenu pour sa note
3. Il enregistre la note en cliquant sur l'icône de sauvegarde

**Consultation des notes :**
1. Les notes sont affichées dans l'écran principal
2. L'utilisateur peut faire défiler la liste pour voir toutes ses notes
3. Il peut trier les notes par date (croissant/décroissant)
4. Il peut rechercher des notes spécifiques via la barre de recherche

**Modification d'une note :**
1. L'utilisateur clique sur une note existante pour la consulter
2. Il clique sur l'icône d'édition pour la modifier
3. Il effectue ses modifications et enregistre

**Suppression d'une note :**
1. Sur l'écran de détail, l'utilisateur clique sur l'icône de suppression
2. Une confirmation est demandée
3. Après confirmation, la note est supprimée de manière permanente
4. Alternativement, il peut faire glisser une note vers la gauche dans la liste principale pour la supprimer

### 3. Partage et Collaboration

**Partage d'une note :**
1. L'utilisateur ouvre une note et clique sur l'icône de partage
2. Il saisit l'email ou le nom d'utilisateur du destinataire
3. Le destinataire reçoit une notification et peut accéder à la note partagée
4. Les notes partagées sont marquées d'une icône spécifique

**Collaboration en temps réel (fonctionnalité future) :**
1. Plusieurs utilisateurs pourront modifier une note simultanément
2. Les modifications seront visibles en temps réel
3. Un indicateur montrera qui est en train d'éditer la note

### 4. Organisation des Notes

**Gestion par importance :**
1. L'utilisateur peut marquer une note comme importante
2. Les notes importantes sont mises en évidence dans la liste

**Filtrage et tri :**
1. Les notes peuvent être triées par date de création
2. L'utilisateur peut rechercher des notes par leur contenu

### 5. Gestion du Profil

**Consultation du profil :**
1. L'utilisateur accède à son profil via l'icône de profil dans l'écran principal
2. Il peut voir ses statistiques (nombre de notes, notes partagées, etc.)

**Modification du profil (fonctionnalité future) :**
1. L'utilisateur pourra modifier ses informations personnelles
2. Il pourra changer sa photo de profil

**Gestion des paramètres :**
1. L'utilisateur peut activer/désactiver le thème sombre
2. Il peut configurer les notifications (fonctionnalité future)

### 6. Déconnexion

1. L'utilisateur accède à son profil
2. Il clique sur le bouton de déconnexion
3. Une confirmation est demandée
4. Après confirmation, l'utilisateur est redirigé vers l'écran de connexion


