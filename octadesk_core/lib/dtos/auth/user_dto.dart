class UserDTO {
  final String id;
  final String firstName;
  final String email;
  final String? avatarURL;
  final String? lastName;

  UserDTO({required this.id, required this.firstName, required this.email, required this.avatarURL, required this.lastName});

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map["id"],
      firstName: map["firstName"],
      email: map["email"],
      avatarURL: map["avatarURL"],
      lastName: map["lastName"],
    );
  }
}
