import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab6/models/Transaction.dart';

import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions) {
    print('Constructor Chart');
  }

 List<Map<String, Object>> get groupedTransactionValues {
  return List.generate(7, (index) {
    final weekDay = DateTime.now().subtract(
      Duration(days: index),
    );
    double totalSum = 0.0; // Ensuring totalSum is double

    for (var i = 0; i < recentTransactions.length; i++) {
      final transaction = recentTransactions[i];
      if (transaction.date.day == weekDay.day &&
          transaction.date.month == weekDay.month &&
          transaction.date.year == weekDay.year) {
        totalSum += transaction.amount;
      }
    }

    return {
      'day': DateFormat.E().format(weekDay).substring(0, 1),
      'amount': totalSum, // Now 'amount' is explicitly double
    };
  }).reversed.toList();
}


 double get totalSpending {
  return groupedTransactionValues.fold(0.0, (sum, item) {
    final amount = item['amount'];
    return sum + (amount != null ? amount as double : 0.0);
  });
}

@override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            final day = data['day'] as String; // Explicit cast to String
            final amount = data['amount'] as double; // Explicit cast to double

            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                day,
                amount,
                totalSpending == 0.0 ? 0.0 : amount / totalSpending, // Safe division
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}