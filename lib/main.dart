import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Player/custom_player.dart';
import 'package:spotify_clone/navbar.dart';
import 'package:spotify_clone/repo/navbar_provider.dart';
import 'package:spotify_clone/repo/user_info.dart';
import 'package:spotify_clone/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify_clone/ui/sign_up_screen.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>CustomPlayerProvider()),
        ChangeNotifierProvider(create: (_)=>UserInformationProvider()),
        ChangeNotifierProvider(create: (_)=>NavBarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SignUpScreen()
      ),
    );
  }
}

