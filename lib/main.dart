import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/auth/auth.dart';
import 'package:usersms/auth/forgotpassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/resources/camerapicker.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/splashscreen.dart';
import 'firebase_options.dart';
import 'resources/image_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await Hive.initFlutter();
  await Hive.openBox('Talk');

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
    return BlocProvider(
      create: (context) => Fetchdatacubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.black, surfaceTintColor: Colors.black),
          fontFamily: 'joel',
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: "joel",
                bodyColor: Colors.white, //<-- SEE HERE
                displayColor: Colors.white, //<-- SEE HERE
              ),
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const Home(),
        routes: <String, WidgetBuilder>{
          //  '/auth': (_) => const Authpage(),
          '/change': (_) => const ForgotPassword(),
          '/home': (_) => const Homepage(),
          //'/post': (_) => const AlbumPage(),
          '/search': (_) => const SearchScreen(),
          //'/story': (_) => const StoryScreen(images: imageList),
          '/camera': (_) => const AddPostScreen()
        },
      ),
    );
  }
}
