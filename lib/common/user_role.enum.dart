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
}