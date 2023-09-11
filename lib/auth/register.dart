import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/auth/google_auth.dart';
import 'package:usersms/glassbox.dart';

class Register extends StatefulWidget {
  final VoidCallback showloginpage;
  const Register({super.key, required this.showloginpage});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final firstNameControllerR = TextEditingController();
  final lastNameControllerR = TextEditingController();
  final emailAddressControllerR = TextEditingController();
  final passwordControllerR = TextEditingController();
  final passwordController = TextEditingController();
  bool isloading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //register
  Future register() async {
    try {
      setState(() {
        isloading = true;
      });
      if (passwordconfirm()) {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddressControllerR.text.trim(),
            password: passwordController.text.trim());

            //create user document on firestore
            _firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
              "uid": FirebaseAuth.instance.currentUser!.uid,
              "email": FirebaseAuth.instance.currentUser!.email
            });
      } else {
        CherryToast.error(
                title: const Text(""),
                backgroundColor: Colors.black45,
                displayTitle: false,
                description: const Text(
                  "Password Mismatch",
                  style: TextStyle(color: Colors.white),
                ),
                animationDuration: const Duration(seconds: 1),
                autoDismiss: true)
            .show(context);
      }
    } on FirebaseAuthException catch (e) {
      CherryToast.error(
              title: const Text(""),
              backgroundColor: Colors.black45,
              displayTitle: false,
              description: Text(
                e.message.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              animationDuration: const Duration(seconds: 1),
              autoDismiss: true)
          .show(context);
    } finally {
      setState(() {
        isloading = true;
      });
    }
  }

  //confirm password
  bool passwordconfirm() {
    if (passwordControllerR.text.trim() == passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    firstNameControllerR.dispose();
    lastNameControllerR.dispose();
    emailAddressControllerR.dispose();
    passwordController.dispose();
    passwordControllerR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/airtime.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.49)),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Text(
                  "Nice to meet you.",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey)),
                ),
              ),
              FadeInDown(
                child: Center(
                  child: Text(
                    "Campus Talk",
                    style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: firstNameControllerR,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "First name",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: lastNameControllerR,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Last name",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: emailAddressControllerR,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: passwordControllerR,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: register,
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(9)),
                    child: Center(
                        child: isloading
                            ? const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: widget.showloginpage,
                      child: const Text(
                        "Have an account? Log in",
                        style: TextStyle(color: Colors.grey),
                      )),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child: const GlassBox(
                        height: 70.0,
                        width: 70.0,
                        child: Center(
                          child: Image(
                            height: 40,
                            width: 40,
                            image: AssetImage("assets/google.png"),
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                  const GlassBox(
                      height: 70.0,
                      width: 70.0,
                      child: Center(
                        child: Image(
                          height: 50,
                          width: 50,
                          image: AssetImage("assets/facebook.png"),
                          fit: BoxFit.contain,
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
