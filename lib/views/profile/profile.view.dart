import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilapp/providers/user.provider.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/auth/signin.view.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: userProvider.currentUser == null
                ? _buildSetProfileButton(context)
                : _buildUserProfile(context, userProvider.currentUser!),
          );
        },
      ),
    );
  }

  Widget _buildSetProfileButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: CustomFilledButton(
          text: 'Set Profile',
          onPressed: () => _navigateToSetProfileView(context),
        ),
      ).animate().fade().scale(),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/100'),
              ).animate().fade().scale(),
            ),
            const SizedBox(height: 24),
            _buildInfoSection('Name', user.name),
            _buildInfoSection('Email', user.email),
            _buildInfoSection('Phone Number', user.phoneNumber),
            _buildInfoSection('City', user.city),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 300,
                child: CustomFilledButton(
                  onPressed: () =>
                      _navigateToSetProfileView(context, user: user),
                  text: "Singout",
                ),
              ),
            ),
          ].animate(interval: 100.ms).fadeIn(duration: 500.ms).slideX(),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _navigateToSetProfileView(BuildContext context,
      {UserModel? user}) async {
    await FirebaseAuth.instance.signOut();
    context.navigator(context, const LoginPage(), shouldBack: false);
  }
}
