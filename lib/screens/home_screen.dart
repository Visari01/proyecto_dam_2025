import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';
import '../widgets/expense_card.dart';
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
    final allExpenses = await db.getAllExpenses();
    setState(() {
      recentExpenses = allExpenses.reversed.take(3).toList();
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
              else
                ...recentExpenses.map((e) => ExpenseCard(expense: e)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
