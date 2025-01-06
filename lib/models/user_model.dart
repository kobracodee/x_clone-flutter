class UserModel {
  final int id;
  final String username;
  final String email;
  final String bio;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id']),
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
    );
  }
}
