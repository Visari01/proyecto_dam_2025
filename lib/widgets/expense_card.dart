import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMM yyyy',
      'es_ES',
    ).format(expense.date);
    final formattedAmount = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '',
      decimalDigits: 2,
    ).format(expense.amount);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        side:
            isSelected
                ? const BorderSide(color: Colors.blue, width: 2)
                : BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        title: Text(formattedDate),
        trailing: Text(
          '${expense.amount >= 0 ? '+' : ''}$formattedAmount',
          style: TextStyle(
            color: expense.amount >= 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
