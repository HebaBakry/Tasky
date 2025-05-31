import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';

class UserDetailsController with ChangeNotifier {
  late final TextEditingController userNameController;

  late final TextEditingController motivationQuoteController;
  late String username;
  late String motivationQuote;

  final GlobalKey<FormState> key = GlobalKey();

  init() {
    loadData();
  }

  void loadData() async {
    username = PreferencesManager().getString(StorageKey.username) ?? '';
    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote) ??
        "One task at a time. One step closer.";
    userNameController = TextEditingController(text: username);
    motivationQuoteController = TextEditingController(text: motivationQuote);
  }
}
