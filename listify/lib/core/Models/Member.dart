class ListMember{

  String userId;

  String role;

  ListMember({required this.userId, required this.role});

  factory ListMember.fromMap(Map<String, dynamic> map) {
    return ListMember(
      userId: map['userId'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'role': role,
    };
  }
}