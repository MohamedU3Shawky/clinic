import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static late SharedPreferences sharedPreferences;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      try {
        sharedPreferences = await SharedPreferences.getInstance();
        _isInitialized = true;
        log('CashHelper initialized successfully');
      } catch (e) {
        log('Failed to initialize SharedPreferences: $e');
      }
    }
  }

  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (!_isInitialized) {
      log('Warning: Attempting to save data before CashHelper is initialized');
      await init();
    }
    
    try {
      log('Saving data with key: $key, value: $value');
      if (value is double) {
        return await sharedPreferences.setDouble(key, value);
      } else if (value is int) {
        return await sharedPreferences.setInt(key, value);
      } else if (value is bool) {
        return await sharedPreferences.setBool(key, value);
      } else if (value is String) {
        return await sharedPreferences.setString(key, value);
      } else if (value is Object) {
        String jsonString = jsonEncode(value);
        return await sharedPreferences.setString(key, jsonString);
      } else {
        log('Unsupported data type for key: $key, value: $value');
        return false;
      }
    } catch (e) {
      log('Error saving data for key: $key, error: $e');
      return false;
    }
  }

  static dynamic getData({required String key}) {
    if (!_isInitialized) {
      log('Warning: Attempting to get data before CashHelper is initialized');
      // Cannot initialize here since this method is not async
      return null;
    }
    
    try {
      log('Retrieving data with key: $key');
      if (!sharedPreferences.containsKey(key)) {
        log('Key not found in SharedPreferences: $key');
        return null;
      }
      
      var value = sharedPreferences.get(key);
      if (value == null) {
        log('Value is null for key: $key');
        return null;
      }
      
      if (value is String) {
        try {
          return jsonDecode(value);
        } catch (e) {
          log('Error decoding JSON for key: $key, error: $e');
          return value;
        }
      }
      return value;
    } catch (e) {
      log('Error retrieving data for key: $key, error: $e');
      return null;
    }
  }

  static Future<bool> removeData({required String key}) async {
    if (!_isInitialized) {
      log('Warning: Attempting to remove data before CashHelper is initialized');
      await init();
    }
    
    try {
      log('Removing data with key: $key');
      return await sharedPreferences.remove(key);
    } catch (e) {
      log('Error removing data for key: $key, error: $e');
      return false;
    }
  }

  static Future<void> clearAllData() async {
    try {
      if (!_isInitialized) {
        sharedPreferences = await SharedPreferences.getInstance();
        _isInitialized = true;
      }
      
      log('Clearing all data from SharedPreferences');
      await sharedPreferences.clear();
    } catch (e) {
      log('Error clearing all data: $e');
    }
  }
}