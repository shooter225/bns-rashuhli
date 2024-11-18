class UserModel {
  final String id;
  final String? userRole;
  final String name;
  final String email;
  final String? location;
  final String? imageUrl;

  final String createdAt;

  UserModel({
    required this.name,
    required this.id,
    required this.userRole,
    required this.email,
    required this.createdAt,
    this.imageUrl,
    this.location,
  });
  factory UserModel.fromJson(json, String createdAt) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        userRole: json['user_role'],
        email: json['email'],
        location: json['location'],
        imageUrl: json['image_url'],
        createdAt: createdAt);
  }
}
