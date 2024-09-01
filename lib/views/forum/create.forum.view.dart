import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soilapp/services/category.service.dart';
import 'package:soilapp/services/post.service.dart';
import 'package:soilapp/services/file.service.dart';
import 'package:soilapp/models/post.model.dart';
import 'package:soilapp/widgets/custom.input.field.dart';
import 'package:soilapp/widgets/custom_filled_button.dart';

class CreateForum extends StatefulWidget {
  const CreateForum({Key? key}) : super(key: key);

  @override
  _CreateForumState createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final PostService _postService = PostService();
  final FileService _fileService = FileService();
  final ImagePicker _imagePicker = ImagePicker();
  String predictedCategory = 'Other';
  File? _image;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _fileService.uploadFile(_image!);
      }
      String? category =
          await CategoryService().predictCategory(_descriptionController.text);
      if (category != null) {
        setState(() {
          predictedCategory = category;
        });
      }
      final newPost = PostModel(
        title: _titleController.text,
        description: _descriptionController.text,
        category: predictedCategory,
        imageUrl: imageUrl,
        posedBy: FirebaseAuth.instance.currentUser?.uid ?? 'Anonymous',
        postedAt: DateTime.now(),
      );

      await _postService.createPost(newPost);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create post: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;

        _titleController.clear();
        _descriptionController.clear();
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInputField(
              label: 'Title',
              hint: 'Enter post title',
              controller: _titleController,
            ),
            const SizedBox(height: 16.0),
            CustomInputField(
              label: 'Description',
              hint: 'Enter post description',
              controller: _descriptionController,
              inputType: TextInputType.multiline,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            if (_image != null) ...[
              const SizedBox(height: 16.0),
              Image.file(_image!, height: 200),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16.0),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24.0),
            CustomFilledButton(
              loading: _isLoading,
              onPressed: _isLoading ? () {} : _createPost,
              text: 'Create Post',
            ),
          ],
        ),
      ),
    );
  }
}
