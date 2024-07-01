import 'package:flutter/material.dart';
import '../widgets/user_info_form.dart';
import '../models/user_model.dart';

class UserInfoFormPage extends StatelessWidget {
  final UserModel? user;

  UserInfoFormPage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('User Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
      ),
      body: UserInfoForm(user: user), // Pass the user parameter to UserInfoForm
    );
  }
}
