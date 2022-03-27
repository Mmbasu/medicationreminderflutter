
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

  Future addStringToSF(String key, String value) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);

  }

  Future<String?> getStringValuesSF(String key) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final image = preferences.getString(key);
    return image;

  }

  Future addBooleanToSF(String key, bool value) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);

  }
}