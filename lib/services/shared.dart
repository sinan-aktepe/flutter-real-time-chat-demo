import 'package:shared_preferences/shared_preferences.dart';

class Shared {

  keepUsername(String key, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, username);
  }

  keepGender(String key, String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, gender);
  }

  keepRoom(String key, String roomUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, roomUrl);
  }

  keepTime(String key, String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, time);
  }

  Future<String> getUsername() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String username = user.getString("username");
    return username;
  }

  Future<String> getGender() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String gender = user.getString("gender");
    return gender;
  }

  Future<String> getRoomUrl() async {
    SharedPreferences room = await SharedPreferences.getInstance();
    String url = room.getString("roomUrl");
    return url;
  }

  Future<String> getCurrentTime() async {
    SharedPreferences time = await SharedPreferences.getInstance();
    String currentTime = time.getString("currentTime");
    return currentTime;
  }
}
