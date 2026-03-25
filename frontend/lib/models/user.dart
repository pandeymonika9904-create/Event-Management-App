class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? phone;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.phone,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'User',
      token: json['token'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'phone': phone,
      'profileImage': profileImage,
    };
  }
}
