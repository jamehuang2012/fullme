import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();

  factory ConfigManager() {
    return _instance;
  }

  ConfigManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    if (kDebugMode) {
      print ("init() parameters");
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      bool? hasReadAlready = _prefs?.getBool("init");

      if (hasReadAlready == null || hasReadAlready == false) {
        if (kDebugMode) {
          print ("set parameters");
        }
        _prefs?.setBool("init", true);
        setUrl("51.222.84.239");
        setPort("1883");
      }  else {
        if (kDebugMode) {
          print ("load parameters");
        }
      }

    } catch (e) {
        if (kDebugMode) {
          print (e);
        }
    }
  }


  // Setters
  Future<void> setUrl(String url) async {
    await _prefs?.setString('url', url);
  }

  Future<void> setPort(String port) async {
    await _prefs?.setString('port', port);
  }

  Future<void> setTopic(String topic) async {
    await _prefs?.setString('topic', topic);
  }

  Future<void> setId(String id) async {
    await _prefs?.setString('id', id);
  }

  Future<void> setImageNumber(String imageNumber) async {
    await _prefs?.setString('imageNumber', imageNumber);
  }

  Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  Future<void> setPassword(String password) async {
    await _prefs?.setString('password', password);
  }

  // Getters
  String getUrl() {

    return _prefs?.getString('url') ?? '';
  }

  String getPort() {
    return _prefs?.getString('port') ?? '';
  }

  String getTopic() {
    return _prefs?.getString('topic') ?? '';
  }

  String getId() {
    return _prefs?.getString('id') ?? '';
  }

  String getImageNumber() {
    return _prefs?.getString('imageNumber') ?? '';
  }

  String getUsername() {
    return _prefs?.getString('username') ?? '';
  }

  String getPassword() {
    return _prefs?.getString('password') ?? '';
  }

  // Clear all settings
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
