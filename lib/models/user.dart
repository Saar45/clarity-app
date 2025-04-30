class User {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });
  
  // Empty user
  factory User.empty() => User(id: '', name: '', email: '', passwordHash: '');
  
  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
    );
  }
  
  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
    };
  }
  
  // Check if the user is valid
  bool get isValid => id.isNotEmpty;
  
  // Generate email display name (first part of email)
  String get emailName {
    if (email.contains('@')) {
      return email.split('@')[0];
    }
    return email;
  }
}
