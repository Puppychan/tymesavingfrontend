import 'package:flutter/material.dart';

enum Rank {
  classic(Colors.grey),
  silver(Colors.blueGrey),
  gold(Colors.amber),
  platinum(Colors.lightBlueAccent);

  final Color color;

  const Rank(this.color);

  static Color getRankColor(String rank) {
    switch (rank) {
      case 'Classic':
        return Rank.classic.color;
      case 'Silver':
        return Rank.silver.color;
      case 'Gold':
        return Rank.gold.color;
      case 'Platinum':
        return Rank.platinum.color;
      default:
        return Colors.black; // Default color if the rank doesn't match
    }
  }
}