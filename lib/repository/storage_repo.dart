import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  Future<String?> getUser() async {
    SharedPreferences storageDb = await SharedPreferences.getInstance();
    return storageDb.getString("user");
  }

  Future<bool> setUser(String user) async {
    SharedPreferences storageDb = await SharedPreferences.getInstance();
    return storageDb.setString("user", user);
  }
}
