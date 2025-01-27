import 'package:chat_room/pages/groupInfoScreen.dart';
import 'package:chat_room/pages/mainScreen.dart';
import 'package:chat_room/pages/settingsScreen.dart';
import 'package:chat_room/pages/splashScreen.dart';
import 'package:chat_room/services/themeDataService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_room/pages/chatScreen.dart';
import 'package:chat_room/pages/loginScreen.dart';
import 'package:chat_room/pages/registrationScreen.dart';
import 'package:chat_room/pages/welcome_screen.dart';
import 'package:chat_room/pages/profileCreate.dart';
import 'package:chat_room/pages/profileUserShow.dart';
import 'package:chat_room/pages/searchGroupsScreen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ThemeDataService.setUpAppThemes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        loginScreen.id: (context) => loginScreen(),
        regScreen.id: (context) => const regScreen(),
        profileCreate.id: (context) => const profileCreate(),
        MainScreen.id: (context) => const MainScreen(),
        SearchGroupsScreen.id: (context) => const SearchGroupsScreen(),
        chatScreen.id: (context) => chatScreen(),
        profileUserShow.id: (context) => const profileUserShow(),
        SettingsScreen.id: (context) => const SettingsScreen(),
        GroupInfoScreen.id: (context) => const GroupInfoScreen(),
      },
    );
  }
}
