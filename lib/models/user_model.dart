class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? role;
  final Map<String, dynamic>? clientProfile;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.role,
    this.clientProfile,
  });

  bool get estPatient => role == null || role == 'client';

  String get nomComplet {
    final parts = [firstName, lastName].where((e) => e != null && e.isNotEmpty);
    if (parts.isEmpty) return username ?? '';
    return parts.join(' ');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: (json['first_name'] ?? json['firstName']) as String?,
      lastName: (json['last_name'] ?? json['lastName']) as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      clientProfile: json['client_profile'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'role': role,
        'client_profile': clientProfile,
      };
}
