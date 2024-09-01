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

  await Firebase.initializeApp();
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
