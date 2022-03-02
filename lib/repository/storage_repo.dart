import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  Future<String?> getUser() async {
    SharedPreferences storageDb = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 2000));

    storageDb.remove("user");
    return storageDb.getString("user");
  }

  Future<bool> setUser(String user) async {
    SharedPreferences storageDb = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 2000));

    return storageDb.setString("user", user);
  }
}
