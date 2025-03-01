import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_history_keeper/core/helper/settings_helper.dart';
import 'package:price_history_keeper/model/transaction.dart';
import 'package:price_history_keeper/view_model/trasaction_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _currency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  void _loadCurrency() async {
    final currency = await SettingsHelper.getCurrency();
    setState(() {
      _currency = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionViewModelProvider);
    final viewModel = ref.read(transactionViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, viewModel),
              _buildBalanceCard(context, viewModel),
              _buildQuickActions(context, viewModel),
              _buildExpenseChart(context, viewModel),
              _buildRecentTransactions(context, transactions, viewModel),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context, viewModel),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TransactionViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Expense Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.nightlight_round),
                onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
      BuildContext context, TransactionViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_currency ${viewModel.getTotalBalance().toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                  'Income', viewModel.getTotalIncome(), Colors.green),
              _buildBalanceItem(
                  'Expense', viewModel.getTotalExpense(), Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$_currency ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
      BuildContext context, TransactionViewModel viewModel) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildQuickAction(
              context,
              'Add Expense',
              Icons.remove,
              Colors.red,
              () => _showAddTransactionDialog(context, viewModel,
                  isExpense: true)),
          _buildQuickAction(
              context,
              'Add Income',
              Icons.add,
              Colors.green,
              () => _showAddTransactionDialog(context, viewModel,
                  isExpense: false)),
          _buildQuickAction(context, 'Categories', Icons.category,
              Colors.orange, () => _showCategoriesDialog(context)),
          _buildQuickAction(context, 'Reports', Icons.bar_chart, Colors.blue,
              () => _showReportsDialog(context, viewModel)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(
      BuildContext context, TransactionViewModel viewModel) {
    final categoryTotals = viewModel.getCategoryTotals();
    final totalExpense = viewModel.getTotalExpense();

    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      child: PieChart(
        PieChartData(
          sections: categoryTotals.entries.map((entry) {
            final percentage = (entry.value / totalExpense) * 100;
            return PieChartSectionData(
              color: Colors.primaries[
                  categoryTotals.keys.toList().indexOf(entry.key) %
                      Colors.primaries.length],
              value: entry.value,
              title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context,
      List<TransactionModel> transactions, TransactionViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length > 5 ? 5 : transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _buildTransactionItem(context, transaction, viewModel);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context,
      TransactionModel transaction, TransactionViewModel viewModel) {
    return Dismissible(
      key: Key(transaction.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        viewModel.deleteTransaction(transaction.id!);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isExpense ? Colors.red : Colors.green,
          child: Icon(
            transaction.isExpense ? Icons.remove : Icons.add,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(transaction.category),
        trailing: Text(
          '${transaction.isExpense ? '-' : '+'}$_currency ${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(
      BuildContext context, TransactionViewModel viewModel,
      {bool isExpense = true}) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = TransactionViewModel.categories.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isExpense ? 'Add Expense' : 'Add Income'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount ($_currency)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                selectedCategory = value!;
              },
              items: TransactionViewModel.categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                final transaction = TransactionModel(
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  date: DateTime.now(),
                  category: selectedCategory,
                  isExpense: isExpense,
                );
                viewModel.addTransaction(transaction);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Categories'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TransactionViewModel.categories
              .map((category) => ListTile(
                    title: Text(category),
                    leading: Icon(
                      Icons.category,
                      color: Colors.primaries[
                          TransactionViewModel.categories.indexOf(category) %
                              Colors.primaries.length],
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog(
      BuildContext context, TransactionViewModel viewModel) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final dailyTotals = viewModel.getDailyTotals(startOfMonth, endOfMonth);
    final averageDailyExpense =
        viewModel.getAverageDailyExpense(startOfMonth, endOfMonth);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monthly Report'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Average Daily Expense: $_currency ${averageDailyExpense.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final date =
                                startOfMonth.add(Duration(days: value.toInt()));
                            return Text(DateFormat('dd').format(date));
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: endOfMonth.difference(startOfMonth).inDays.toDouble(),
                    minY: dailyTotals.values.reduce((a, b) => a < b ? a : b),
                    maxY: dailyTotals.values.reduce((a, b) => a > b ? a : b),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dailyTotals.entries.map((entry) {
                          final date = DateTime.parse(entry.key);
                          return FlSpot(
                            date.difference(startOfMonth).inDays.toDouble(),
                            entry.value,
                          );
                        }).toList(),
                        isCurved: true,
                        //  colors: [Colors.blue],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          //  colors: [Colors.blue.withOpacity(0.3)
                          //  ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Currency'),
              trailing: DropdownButton<String>(
                value: _currency,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currency = newValue;
                    });
                    SettingsHelper.setCurrency(newValue);
                  }
                },
                items: ['USD', 'EUR', 'GBP', 'JPY', 'PKR']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                ref.read(themeProvider.notifier).toggleTheme();
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: true, // You can implement this using SharedPreferences
              onChanged: (bool value) {
                // Implement notification settings
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
