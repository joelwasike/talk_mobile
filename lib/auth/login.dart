import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/glassbox.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:usersms/resources/apiconstatnts.dart';

class Login extends StatefulWidget {
  final VoidCallback showregisterPage;
  const Login({super.key, required this.showregisterPage});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailconroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  bool isloading = false;

  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });
    Map body = {"email": emailconroller.text};
    final url = Uri.parse('$baseUrl/getuserdetails');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      var box = Hive.box("Talk");
      box.put("id", jsonData[0]["ID"]);
      box.put("username", jsonData[0]["username"]);
      box.put("email", jsonData[0]["email"]);
      box.put("profile_picture", jsonData[0]["profile_picture"]);
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future login() async {
    try {
      await fetchData();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailconroller.text.trim(),
          password: passwordcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      CherryToast.error(
              title: const Text(""),
              backgroundColor: Colors.black45,
              displayTitle: false,
              description: Text(
                e.message.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              animationDuration: const Duration(milliseconds: 500),
              autoDismiss: true)
          .show(context);
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailconroller.dispose();
    passwordcontroller.dispose();
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
                  "Welcome back.",
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
                  controller: emailconroller,
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
                  controller: passwordcontroller,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: widget.showregisterPage,
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.grey),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/change');
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
              GestureDetector(
                onTap: login,
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
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ))),
              ),
              const SizedBox(
                height: 50,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     GestureDetector(
              //       onTap: () => AuthService().signInWithGoogle(),
              //       child: const GlassBox(
              //           height: 70.0,
              //           width: 70.0,
              //           child: Center(
              //             child: Image(
              //               height: 40,
              //               width: 40,
              //               image: AssetImage("assets/google.png"),
              //               fit: BoxFit.contain,
              //             ),
              //           )),
              //     ),
              //     const GlassBox(
              //         height: 70.0,
              //         width: 70.0,
              //         child: Center(
              //           child: Image(
              //             height: 50,
              //             width: 50,
              //             image: AssetImage("assets/facebook.png"),
              //             fit: BoxFit.contain,
              //           ),
              //         ))
              //   ],
              // )
            ],
          ),
        ));
  }
}
