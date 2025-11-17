import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> transactions = [];

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("transactions");

    if (data != null) {
      List decoded = jsonDecode(data);
      transactions = decoded.map((e) => TransactionModel.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(transactions.map((e) => e.toJson()).toList());
    prefs.setString("transactions", encoded);
  }

  void addTransaction(TransactionModel trx) {
    transactions.add(trx);
    saveData();
    notifyListeners();
  }

  void updateTransaction(TransactionModel trx) {
    int index = transactions.indexWhere((e) => e.id == trx.id);
    transactions[index] = trx;
    saveData();
    notifyListeners();
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((e) => e.id == id);
    saveData();
    notifyListeners();
  }

  int get totalIncome =>
      transactions.where((e) => e.type == "income").fold(0, (a, b) => a + b.amount);

  int get totalExpense =>
      transactions.where((e) => e.type == "expense").fold(0, (a, b) => a + b.amount);

  int get balance => totalIncome - totalExpense;
}
