import 'package:flutter/material.dart';
import 'package:usersms/auth/login.dart';
import 'package:usersms/auth/register.dart';


class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showloginpage = true;

  void tooglepages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return Login(showregisterPage: tooglepages);
    } else {
      return Register(showloginpage: tooglepages);
    }
  }
}
