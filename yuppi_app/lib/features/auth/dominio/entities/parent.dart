class Parent {
  final String id;
  final String user;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String stateCountry;
  final String passwordHash;

  const Parent({
    required this.id,
    required this.email,
    required this.fullName,
    required this.user,
    required this.phoneNumber,
    required this.stateCountry,
    required this.passwordHash,
  });

  Parent copyWith({
    String? email,
    String? fullName,
    String? user,
    String? phoneNumber,
    String? stateCountry,
    String? passwordHash,
  }) {
    return Parent(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      user: user ?? this.user,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      stateCountry: stateCountry ?? this.stateCountry,
      passwordHash:
          (passwordHash == null || passwordHash.isEmpty)
              ? this.passwordHash
              : passwordHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'user': user,
      'phoneNumber': phoneNumber,
      'stateCountry': stateCountry,
      'passwordHash': passwordHash,
    };
  }
}
