import 'package:flutter/material.dart';
import 'package:soilapp/services/auth_service.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/auth/signup.view.dart';
import 'package:soilapp/views/view.container.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';
import 'package:soilapp/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.flutter_dash,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 48.0),
                CustomTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  onSaved: (value) => _email = value ?? '',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  hintText: 'Password',
                  obscureText: true,
                  validator: _validatePassword,
                  onSaved: (value) => _password = value ?? '',
                ),
                const SizedBox(height: 24.0),
                CustomFilledButton(
                  loading: loading,
                  text: 'Log in',
                  onPressed: _submit,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        child: const Text('Sign up'),
                        onPressed: () {
                          context.navigator(context, SignupPage());
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Add more email validation if needed
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Add more password validation if needed
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        _formKey.currentState!.save();

        await AuthService().login(_email, _password);
        context.navigator(context, const ViewContainer(), shouldBack: false);
      } catch (e) {
        context.showSnackBar("Error $e");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
