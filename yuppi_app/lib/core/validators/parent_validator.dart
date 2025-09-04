abstract class ParentValidator {
  Future<bool> emailExists(String email, {String? excludeId});
  Future<bool> usernameExists(String username, {String? excludeId});
  Future<bool> phoneNumberExists(String phoneNumber, {String? excludeId});
}
