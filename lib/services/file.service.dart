import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  Future<String> uploadFile(File file, {String? customFileName}) async {
    try {
      // Generate a unique file name if not provided
      String fileName =
          customFileName ?? '${_uuid.v4()}${path.extension(file.path)}';

      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = _storage.ref().child('uploads/$fileName');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait until the file is uploaded then fetch the download URL
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Failed to upload file');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      // Create a reference to the file to delete
      Reference ref = _storage.refFromURL(fileUrl);

      // Delete the file
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Failed to delete file');
    }
  }

  Future<String> getFileExtension(String fileUrl) async {
    try {
      // Create a reference to the file
      Reference ref = _storage.refFromURL(fileUrl);

      // Get the metadata of the file
      FullMetadata metadata = await ref.getMetadata();

      // Return the file extension
      return path.extension(metadata.name ?? '');
    } catch (e) {
      print('Error getting file extension: $e');
      throw Exception('Failed to get file extension');
    }
  }
}
