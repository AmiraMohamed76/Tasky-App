import 'package:flutter/cupertino.dart';
import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';

class HomeController extends ChangeNotifier {

  String? username;
  String? userImagePath;
  late String motivationQuote;
  bool isChecked = false;
  bool isLoading = false;


  init() {
    loadUserData();
  }

  void loadUserData() async {
    username = PreferencesManager().getString(StorageKey.userName);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote) ??
        "One task at a time. One step closer";

    notifyListeners();
  }

}
