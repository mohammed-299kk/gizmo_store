class UserModel {
  final String? id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? photoURL;
  final bool isBlocked;
  final String? role;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserModel({
    this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.photoURL,
    this.isBlocked = false,
    this.role,
    this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? data['displayName'],
      phoneNumber: data['phoneNumber'] ?? data['phone'],
      photoURL: data['photoURL'],
      isBlocked: data['isBlocked'] ?? false,
      role: data['role'],
      createdAt: data['createdAt']?.toDate(),
      lastLogin: data['lastLogin']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'isBlocked': isBlocked,
      'role': role,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }
}
