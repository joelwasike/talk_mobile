import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/auth/forgotpassword.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/resources/camerapicker.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/splashscreen.dart';
import 'package:usersms/utils/app_theme.dart';
import 'package:usersms/utils/error_handler.dart';
import 'resources/image_data.dart';

Future<void> initializeApp() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    
    await Hive.initFlutter();
    await Hive.openBox('Talk');
    
    // Initialize error handling
    ErrorHandler.initialize();
  } catch (e) {
    debugPrint('Error initializing app: $e');
    // Handle initialization errors appropriately
  }
}

void main() async {
  await initializeApp();
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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(),
            ),
            child: child!,
          );
        },
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
        onGenerateRoute: (settings) {
          // Handle 404 errors
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Route ${settings.name} not found'),
              ),
            ),
          );
        },
      ),
    );
  }
}
