import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_history_keeper/core/helper/db_helper.dart';
import 'package:price_history_keeper/model/transaction.dart';
import 'package:intl/intl.dart';

final transactionViewModelProvider =
    StateNotifierProvider<TransactionViewModel, List<TransactionModel>>((ref) {
  return TransactionViewModel();
});

class TransactionViewModel extends StateNotifier<List<TransactionModel>> {
  TransactionViewModel() : super([]) {
    _loadTransactions();
  }

  static const List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Entertainment',
    'Bills & Utilities',
    'Shopping',
    'Health & Fitness',
    'Travel',
    'Education',
    'Gifts & Donations',
    'Investments',
    'Salary',
    'Other Income',
    'Other Expense'
  ];

  Future<void> _loadTransactions() async {
    final transactions = await DatabaseHelper.instance.getTransactions();
    state = transactions;
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.insertTransaction(transaction);
    _loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.updateTransaction(transaction);
    _loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    _loadTransactions();
  }

  double getTotalBalance() {
    return state.fold(
        0, (sum, item) => sum + (item.isExpense ? -item.amount : item.amount));
  }

  double getTotalIncome() {
    return state
        .where((item) => !item.isExpense)
        .fold(0, (sum, item) => sum + item.amount);
  }

  double getTotalExpense() {
    return state
        .where((item) => item.isExpense)
        .fold(0, (sum, item) => sum + item.amount);
  }

  Map<String, double> getCategoryTotals() {
    final categoryTotals = <String, double>{};
    for (final transaction in state) {
      if (transaction.isExpense) {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return categoryTotals;
  }

  List<TransactionModel> getTransactionsForDateRange(
      DateTime start, DateTime end) {
    return state
        .where((transaction) =>
            transaction.date.isAfter(start) && transaction.date.isBefore(end))
        .toList();
  }

  Map<String, double> getDailyTotals(DateTime start, DateTime end) {
    final dailyTotals = <String, double>{};
    final transactions = getTransactionsForDateRange(start, end);
    for (final transaction in transactions) {
      final dateString = DateFormat('yyyy-MM-dd').format(transaction.date);
      dailyTotals[dateString] = (dailyTotals[dateString] ?? 0) +
          (transaction.isExpense ? -transaction.amount : transaction.amount);
    }
    return dailyTotals;
  }

  double getAverageDailyExpense(DateTime start, DateTime end) {
    final transactions = getTransactionsForDateRange(start, end);
    final totalExpense = transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final days = end.difference(start).inDays + 1;
    return totalExpense / days;
  }
}
