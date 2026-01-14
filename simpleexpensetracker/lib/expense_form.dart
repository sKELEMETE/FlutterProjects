import 'package:flutter/material.dart';
import '../expense.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;
  final void Function(String, double, DateTime) onSubmit;

  const ExpenseForm({super.key, this.expense, required this.onSubmit});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _selectedDate = widget.expense!.date;
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (title.isEmpty || amount <= 0) return;
    widget.onSubmit(title, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
              TextButton(
                onPressed: _pickDate,
                child: const Text('Choose Date'),
              ),
            ],
          ),
          ElevatedButton(onPressed: _submit, child: const Text('Save')),
        ],
      ),
    );
  }
}
