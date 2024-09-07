import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:soilapp/widgets/custom.input.field.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';

class ProfileFormWidget extends StatefulWidget {
  final UserModel? initialData;
  final Function(String, String, String, String, String) onSave;

  const ProfileFormWidget({
    Key? key,
    this.initialData,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProfileFormWidgetState createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late TextEditingController _city;
  late TextEditingController _phoneNumber;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?.name ?? '');
    _emailController = TextEditingController(
        text: widget.initialData?.email ??
            FirebaseAuth.instance.currentUser?.email);
    _descriptionController =
        TextEditingController(text: widget.initialData?.description ?? '');
    _city = TextEditingController(text: widget.initialData?.city ?? '');
    _phoneNumber =
        TextEditingController(text: widget.initialData?.phoneNumber ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomInputField(
            controller: _nameController,
            hint: 'Name',
            label: 'Name',
          ),
          const SizedBox(
            height: 8,
          ),
          CustomInputField(
            controller: _phoneNumber,
            hint: 'Phone',
            label: 'Phone',
            enabled: false,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomInputField(
            controller: _city,
            hint: 'City',
            label: 'City',
            enabled: false,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomInputField(
            controller: _emailController,
            hint: 'Email',
            label: 'Email',
            enabled: false,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomFilledButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text,
                  _emailController.text,
                  _descriptionController.text,
                  _city.text,
                  _phoneNumber.text,
                );
              },
              text: 'Save Profile',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
