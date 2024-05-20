// const String ROLE_CUSTOMER = 'Customer';
// const String ROLE_ADMIN = 'Admin';

enum UserRole {
  customer('Customer'),
  admin('Admin');

  const UserRole(this.name);

  // final String hexCode;
  final String name;

  @override
  String toString() => name;

  static UserRole fromString(String name) {
    for (var role in UserRole.values) {
      if (role.name == name) {
        return role;
      }
    }
    // default to customer
    return UserRole.customer;
  }
}