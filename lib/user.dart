class User{
  User({
    required this.id,
    required this.role,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.pin,
  });

  final String id;
  final String role;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String pin;

} 

User user = User(id: '1', role: 'user', username: 'test',password: 'password', email: 'email',
phone: '0123456789', pin: '8888');