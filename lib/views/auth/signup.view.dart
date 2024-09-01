import 'package:flutter/material.dart';
import 'package:soilapp/services/auth_service.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/home/home.view.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';
import 'package:soilapp/widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  String _email = '';
  String _password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 16.0),
                const SizedBox(height: 24.0),
                CustomFilledButton(
                  loading: loading,
                  text: 'Sign Up',
                  onPressed: _submit,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      child: const Text('Log in'),
                      onPressed: () => Navigator.pop(context),
                    ),
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
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          loading = true;
        });
        await _authService.signUp(_email, _password);
        // Navigate to home page or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );
        context.navigator(context, const HomeView());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
