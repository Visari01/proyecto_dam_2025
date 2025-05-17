import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_database.dart';
import '../widgets/expense_card.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  List<Expense> _expenses = [];
  final _selectedIds = [];
  bool _isSelecting = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final data = await ExpenseDatabase.instance.getAllExpenses();
    setState(() {
      _expenses = data;
      _loading = false;
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Eliminar registros'),
            content: Text(
              '¿Desea eliminar ${_selectedIds.length} registros seleccionados?',
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              TextButton(
                child: Text('Aceptar'),
                onPressed: () async {
                  for (int id in _selectedIds) {
                    await ExpenseDatabase.instance.delete(id);
                  }
                  Navigator.of(ctx).pop();
                  _selectedIds.clear();
                  _isSelecting = false;
                  _loadExpenses();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registros'),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _selectedIds.isEmpty ? null : _confirmDelete,
            )
          else
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isSelecting = true;
                });
              },
            ),
        ],
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _expenses.isEmpty
              ? Center(child: Text('No hay registros'))
              : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _isSelecting = true;
                      });
                      _toggleSelection(expense.id!);
                    },
                    onTap:
                        _isSelecting
                            ? () => _toggleSelection(expense.id!)
                            : null,
                    child: ExpenseCard(
                      expense: expense,
                      isSelected: _selectedIds.contains(expense.id),
                    ),
                  );
                },
              ),
    );
  }
}
