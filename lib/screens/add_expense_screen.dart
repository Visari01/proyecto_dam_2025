import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';

class AddExpenseScreen extends StatefulWidget {
  final VoidCallback onExpenseAdded;

  const AddExpenseScreen({super.key, required this.onExpenseAdded});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'General';

  Future<void> _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
      );
      await ExpenseDatabase.instance.createExpense(newExpense);
      widget.onExpenseAdded();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro agregado con éxito')),
      );

      _descriptionController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedCategory = 'General';
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese una descripción'
                            : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un monto';
                  }
                  final number = double.tryParse(value);
                  if (number == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Fecha:'),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    <String>['General', 'Comida', 'Transporte', 'Otros']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitExpense,
                child: const Text('Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
