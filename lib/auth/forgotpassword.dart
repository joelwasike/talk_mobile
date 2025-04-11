import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/glassbox.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailconroller = TextEditingController();

  Future changePassword() async {
    // try {
    //   FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: emailconroller.text.trim());

    //   CherryToast.info(
    //     animationDuration: const Duration(milliseconds: 500),
    //     backgroundColor: Colors.black45,
    //     title: const Text("Password recovery", style: TextStyle(color: Colors.white),),
    //     action: const Text("Email link sent. Check email",style: TextStyle(color: Colors.white)),
    //     actionHandler: () {
    //       print("Action button pressed");
    //     },
    //   ).show(context);
    // } on FirebaseAuthException catch (e) {
    //   print(e);
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Text(e.message.toString()),
    //         );
    //       });
    // }
  }

  @override
  void dispose() {
    emailconroller.dispose();
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
              Center(
                child: Text(
                  "Enter your email for password recovery.",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 30,
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
              GestureDetector(
                onTap: changePassword,
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(9)),
                    child: const Center(
                        child: Text(
                      "Reset password",
                      style: TextStyle(color: Colors.white),
                    ))),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
