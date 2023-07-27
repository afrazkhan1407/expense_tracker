import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registedExpenses = [
    Expense(
        title: 'Flutter-Course',
        amount: 9899,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 99,
        date: DateTime.now(),
        category: Category.leisure)
  ];
  void overlayExpenseAdd() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _enteredExpense);
        });
  }

  void _enteredExpense(Expense expense) {
    setState(() {
      _registedExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registedExpenses.indexOf(expense);
    setState(() {
      _registedExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deletd'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registedExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.height);
    // print(width);
    Widget mainContent = const Center(
      child: Text(
          'No Expense found , add some Expenses to show!\n\n\n (Developed by Afraz)'),
    );
    if (_registedExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registedExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 18, 18, 48),
        actions: [
          IconButton(onPressed: overlayExpenseAdd, icon: const Icon(Icons.add))
        ],
        // centerTitle: true,
        title: const Text('Flutter Expense Tracker'),
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registedExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registedExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
