import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilapp/providers/user.provider.dart';
import 'package:soilapp/utils/app.theme.view.dart';
import 'package:soilapp/views/auth/signin.view.dart';
import 'package:soilapp/views/view.container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB78pB1YVH0k-Jz8NNxCOD5kD7zX4NkeyE",
          authDomain: "kavinda-f44d7.firebaseapp.com",
          projectId: "kavinda-f44d7",
          storageBucket: "kavinda-f44d7.appspot.com",
          messagingSenderId: "348198548913",
          appId: "1:348198548913:web:2ad4e6972402c8920b7990"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        theme: CustomAppTheme.appTheme(),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : const ViewContainer(),
      ),
    );
  }
}
