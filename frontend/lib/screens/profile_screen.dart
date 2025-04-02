// 用户个人资料页，显示用户信息和评分

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/rating_bar.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(user.email),
            SizedBox(height: 20),
            RatingBar(rating: user.rating),
          ],
        ),
      ),
    );
  }
}
