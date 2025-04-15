import 'package:flutter/material.dart';
import 'package:penghitung_harian/controllers/expense_controller.dart';
import 'package:penghitung_harian/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final ExpenseController controller;
  final VoidCallback onDeleted;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.controller,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          controller.formatCurrency(expense.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${expense.category}\n${expense.description.isEmpty ? 'Tidak ada deskripsi' : expense.description}\n${controller.formatDate(expense.date)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            controller.deleteExpense(expense.id, onDeleted);
          },
        ),
      ),
    );
  }
}
