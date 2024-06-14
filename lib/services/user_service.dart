import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/user.dart';

class UserService extends ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  String _filter = '';

  List<User> get users => _filteredUsers.isNotEmpty ? _filteredUsers : _users;

  void loadUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

  void filterUsers(String group) {
    _filter = group;
    _filteredUsers = _users.where((user) => user.group == group).toList();
    notifyListeners();
  }

  void clearFilter() {
    _filter = '';
    _filteredUsers.clear();
    notifyListeners();
  }
}
