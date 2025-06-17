import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Check if device supports biometrics
  static Future<bool> isBiometricsAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  // Authenticate with biometrics
  static Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Error authenticating: $e');
      return false;
    }
  }

  // Save credentials securely
  static Future<void> saveCredentials(String email, String password) async {
    try {
      final credentials = {
        'email': email,
        'password': password,
      };
      await _secureStorage.write(
        key: 'user_credentials',
        value: jsonEncode(credentials),
      );
      print('credentials saved: $credentials');
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // Get saved credentials
  static Future<Map<String, String>?> getCredentials() async {
    try {
      final credentials = await _secureStorage.read(key: 'user_credentials');
      if (credentials != null) {
        return Map<String, String>.from(jsonDecode(credentials));
      }
      return null;
    } catch (e) {
      print('Error getting credentials: $e');
      return null;
    }
  }

  // Delete saved credentials
  static Future<void> deleteCredentials() async {
    try {
      await _secureStorage.delete(key: 'user_credentials');
    } catch (e) {
      print('Error deleting credentials: $e');
    }
  }
} 