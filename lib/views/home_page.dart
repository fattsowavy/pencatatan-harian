import 'package:flutter/material.dart';
import 'package:penghitung_harian/controllers/expense_controller.dart';
import 'package:penghitung_harian/services/expense_service.dart';
import 'package:penghitung_harian/widgets/expense_card.dart';

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  late ExpenseController controller;

  @override
  void initState() {
    super.initState();
    controller = ExpenseController(ExpenseService());
    controller.loadExpenses().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = controller.calculateCategoryTotals();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pencatatan Pengeluaran Harian',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: controller.expenses.isEmpty
          ? const Center(
              child: Text(
                'Belum Ada Pengeluaran Harian',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Macam - Macam Pengeluaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...controller.categories.map((category) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        category,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        controller.formatCurrency(
                                            categoryTotals[category]!),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'History Pengeluaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = controller.expenses[index];
                      return ExpenseCard(
                        expense: expense,
                        controller: controller,
                        onDeleted: () => setState(() {}),
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.showAddExpenseDialog(context, () => setState(() {}));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
