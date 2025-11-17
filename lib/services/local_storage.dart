import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String transactionKey = "transactions";

  static Future<bool> saveTransactions(List<Map<String, dynamic>> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String encoded = jsonEncode(data);
      return await prefs.setString(transactionKey, encoded);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving data: $e");
      }
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> loadTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString(transactionKey);

      if (data == null) return [];
      List decoded = jsonDecode(data);

      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading data: $e");
      }
      return [];
    }
  }
}
