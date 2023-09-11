import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usersms/auth/authconfirm.dart';
import 'package:usersms/widgets/bottomnav.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapsht){
          if (snapsht.hasData) {
            return const BottomNav();
          }else{
            return const Auth();
          }
        },
      )
      

    );
  }
}
