import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:penghitung_harian/models/expense.dart';

class ExpenseService {
  static const String _key = 'expenses';

  Future<List<Expense>> getExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? expensesJson = prefs.getString(_key);
      if (expensesJson == null || expensesJson.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(expensesJson);
      return decoded.map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      print('Error loading pengeluaran: $e');
      return [];
    }
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded =
          jsonEncode(expenses.map((e) => e.toJson()).toList());
      await prefs.setString(_key, encoded);
    } catch (e) {
      print('Error menyimpan pengeluaran: $e');
    }
  }

  Future<void> clearExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      print('Error clearing pengeluaran: $e');
    }
  }
}
