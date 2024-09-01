import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:soilapp/providers/user.provider.dart';
import 'package:soilapp/utils/index.dart';
import 'package:soilapp/views/profile/profile.form.view.dart';
import 'package:soilapp/views/profile/set.profile.view.model.dart';

class SetProfileView extends StatelessWidget {
  final UserModel? currentUser;
  const SetProfileView({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => SetProfileViewModel(provider: provider),
      child: Scaffold(
        appBar: AppBar(title: const Text('Set Profile')),
        body: Consumer<SetProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProfileFormWidget(
              initialData: viewModel.currentUser,
              onSave: (name, email, description) async {
                try {
                  await viewModel.saveProfile(name, email, description);
                  context.showSnackBar('Profile updated successfully');
                  Navigator.pop(context);
                } catch (e) {
                  context.showSnackBar("Error while saving profile");
                  print('Error while saving $e');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
