class ParentProfile {
  final String id;
  final String user;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String stateCountry;
  final String passwordHash;

  const ParentProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.user,
    required this.phoneNumber,
    required this.stateCountry,
    required this.passwordHash,
  });
}
