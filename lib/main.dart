import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gamedatabaseapp/pages/home_page.dart';
import 'package:gamedatabaseapp/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:gamedatabaseapp/components/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:gamedatabaseapp/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
    await DBHelper.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedIndexProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LoginPage(),
      ),
    );
  }
}
