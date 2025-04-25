import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penghitung_harian/models/expense.dart';
import 'package:penghitung_harian/services/expense_service.dart';

class ExpenseController {
  final ExpenseService service;
  List<Expense> expenses = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Makanan';
  final List<String> categories = [
    'Makanan',
    'Transportasi',
    'Entertainment',
    'Tagihan',
    'Lainnya'
  ];

  ExpenseController(this.service);

  Future<void> loadExpenses() async {
    expenses = await service.getExpenses();
  }

  void addExpense(BuildContext context, VoidCallback onExpenseAdded) {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah pengeluaran'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: double.parse(amountController.text),
        category: selectedCategory,
        date: DateTime.now(),
        description: descriptionController.text,
      );
      expenses.add(expense);
      service.saveExpenses(expenses);
      amountController.clear();
      descriptionController.clear();
      selectedCategory = categories[0];
      onExpenseAdded();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding expense: $e')),
      );
    }
  }

  void deleteExpense(String id, VoidCallback onExpenseDeleted) {
    expenses.removeWhere((expense) => expense.id == id);
    service.saveExpenses(expenses);
    onExpenseDeleted();
  }

  Map<String, double> calculateCategoryTotals() {
    final Map<String, double> totals = {};
    for (var category in categories) {
      totals[category] = 0.0;
    }
    for (var expense in expenses) {
      totals[expense.category] = totals[expense.category]! + expense.amount;
    }
    return totals;
  }

  void showAddExpenseDialog(BuildContext context, VoidCallback onExpenseAdded) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masukkan Jumlah Pengeluaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pengeluaran',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp. ',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              addExpense(context, () {
                Navigator.of(context).pop();
                onExpenseAdded();
              });
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
  }
}
