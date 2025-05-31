import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';

class ProfileController with ChangeNotifier {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoading = true;

  init() {
    loadData();
  }

  void loadData() async {
    username = PreferencesManager().getString(StorageKey.username) ?? '';
    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote) ??
        "One task at a time. One step closer.";
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    isLoading = false;
    notifyListeners();
  }

  void saveImage(XFile file) async {
    if (kIsWeb) {
      PreferencesManager().setString(StorageKey.userImage, file.path);
      userImagePath = file.path;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final newFile = await io.File(
        file.path,
      ).copy('${appDir.path}/${file.name}');
      PreferencesManager().setString(StorageKey.userImage, newFile.path);
      userImagePath = newFile.path;
    }

    notifyListeners();
  }

  void showImageSourceDialog(
    BuildContext context,
    Function(XFile) selectedFile,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            'Choose Image Source',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedFile(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedFile(image);
                }
              },
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text('Gallery'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
