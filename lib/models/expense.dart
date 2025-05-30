class Expense {
  final int? id;
  final String description;
  final String category;
  final double amount;
  final DateTime date;

  Expense({
    this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

  Expense copyWith({
    int? id,
    String? description,
    String? category,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
