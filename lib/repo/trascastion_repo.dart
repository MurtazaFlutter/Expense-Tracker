import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_history_keeper/core/helper/db_helper.dart';
import 'package:price_history_keeper/model/transaction.dart';

final transactionViewModelProvider =
    StateNotifierProvider<TransactionViewModel, List<TransactionModel>>((ref) {
  return TransactionViewModel();
});

class TransactionViewModel extends StateNotifier<List<TransactionModel>> {
  TransactionViewModel() : super([]) {
    _loadTransactions();
  }

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
}
