import 'package:flutter/material.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:soilapp/services/app.user.service.dart';
import 'package:soilapp/services/auth_service.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/home/home.view.dart';
import 'package:soilapp/views/view.container.dart';
import 'package:soilapp/widgets/custom.input.field.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool loading = false;
  bool _isExpert = false; // New state variable for the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInputField(
                  label: 'Your Name',
                  hint: "John Doe",
                  inputType: TextInputType.text,
                  controller: _nameController,
                ),
                const SizedBox(height: 16.0),
                CustomInputField(
                  label: 'City',
                  hint: "Colombo",
                  inputType: TextInputType.text,
                  controller: _cityController,
                ),
                const SizedBox(height: 16.0),
                CustomInputField(
                  label: 'Phone Number',
                  hint: "+94710781211",
                  inputType: TextInputType.phone,
                  controller: _phoneNumberController,
                ),
                const SizedBox(height: 16.0),
                CustomInputField(
                  label: 'Email',
                  hint: "Email",
                  inputType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  controller: _emailController,
                ),
                const SizedBox(height: 16.0),
                CustomInputField(
                  hint: 'Password',
                  label: 'Password',
                  isPassword: true,
                  validator: _validatePassword,
                  controller: _passwordController,
                ),
                const SizedBox(height: 16.0),

                // Checkbox for isExpert
                CheckboxListTile(
                  title: const Text('Are you an expert?'),
                  value: _isExpert,
                  onChanged: (bool? value) {
                    setState(() {
                      _isExpert = value ?? false;
                    });
                  },
                ),

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
        await _authService.signUp(
            _emailController.text, _passwordController.text);
        UserModel user = UserModel(
            name: _nameController.text,
            email: _emailController.text,
            phoneNumber: _phoneNumberController.text,
            city: _cityController.text,
            isExpert: _isExpert);
        await UserService().createUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );
        context.navigator(context, const ViewContainer());
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
