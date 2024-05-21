import 'package:flutter/material.dart';

class UserModel {
  final String _name;
  final String _date;
  final String _avatarPath;
  final double _contribution;

  UserModel({
    required String name,
    required String date,
    required String avatarPath,
    required double contribution,
  })  : _name = name,
        _date = date,
        _avatarPath = avatarPath,
        _contribution = contribution;

  String get name => _name;
  String get date => _date;
  String get avatarPath => _avatarPath;
  double get contribution => _contribution;

  static List<UserModel> getUsers() {
    return [
      UserModel(
        name: 'Alice Johnson',
        date: '2024-05-01',
        avatarPath: 'https://source.unsplash.com/random/?person&1',
        contribution: 150.0,
      ),
      UserModel(
        name: 'Bob Smith',
        date: '2024-04-15',
        avatarPath: 'https://source.unsplash.com/random/?person&2',
        contribution: 200.0,
      ),
      UserModel(
        name: 'Charlie Brown',
        date: '2024-03-30',
        avatarPath: 'https://source.unsplash.com/random/?person&3',
        contribution: 180.0,
      ),
      UserModel(
        name: 'Diana Prince',
        date: '2024-02-20',
        avatarPath: 'https://source.unsplash.com/random/?person&4',
        contribution: 220.0,
      ),
      UserModel(
        name: 'Evan Wright',
        date: '2024-01-10',
        avatarPath: 'https://source.unsplash.com/random/?person&5',
        contribution: 160.0,
      ),
    ];
  }
}
