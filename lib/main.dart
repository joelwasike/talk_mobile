import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:usersms/auth/auth.dart';
import 'package:usersms/auth/forgotpassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:usersms/resources/camerapicker.dart';
import 'package:usersms/screens/addpost.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/splashscreen.dart';
import 'package:usersms/widgets/story/screens/story_screen.dart';
import 'firebase_options.dart';
import 'resources/image_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late final ImageData image;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         textTheme:
        Theme.of(context).textTheme.apply(
      bodyColor: Colors.white, //<-- SEE HERE
      displayColor: Colors.white, //<-- SEE HERE
    ),
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xFF121212),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: <String, WidgetBuilder>{
        '/auth': (_) => const Authpage(),
        '/change': (_) =>  const ForgotPassword(),
        '/home': (_) =>  const Homepage(),
        '/post': (_) =>   AlbumPage(),
        '/search': (_) =>  const SearchScreen(),
        '/story': (_) =>  StoryScreen( images: imageList),
         '/camera': (_) =>  AddPostScreen()

      },
       
    );
  }
}
