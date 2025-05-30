import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> recentExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadRecentExpenses();
  }

  Future<void> _loadRecentExpenses() async {
    final db = ExpenseDatabase.instance;
    final allExpenses = await db.getAllExpenses(orderBy: 'id DESC');
    setState(() {
      recentExpenses = allExpenses.take(3).toList();
    });
  }

  String formatAmount(double amount) {
    final format = NumberFormat.currency(
      locale: 'es',
      symbol: '',
      decimalDigits: 2,
    );
    return amount >= 0 ? '+${format.format(amount)}' : format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              if (recentExpenses.isEmpty)
                const Text('No hay registros', style: TextStyle(fontSize: 16))
              else ...[
                const Text(
                  'Recientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ...recentExpenses
                    .map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy', 'es').format(e.date),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                formatAmount(e.amount),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      e.amount >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${e.category} - ${e.description}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const Divider(height: 20),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
