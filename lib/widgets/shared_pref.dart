import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static late SharedPreferences prefs;
  static Future<void> init()async{
    prefs = await SharedPreferences.getInstance();
  }

  static void saveToken(String token){
    prefs.setString("token", token);
  }

  static String? getToken(){
    String?  token =  prefs.getString("token");
    return token;
  }

  /// Remove the Token (Logout): When the user logs out, you can remove the token using:
  static Future<void> removeToken() async {
    await prefs.remove('token');
  }
}

