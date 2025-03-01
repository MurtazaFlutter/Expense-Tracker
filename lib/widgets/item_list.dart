import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ItemList extends ConsumerWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement item list provider
    final items = [
      {
        'name': 'Milk',
        'price': 3.99,
        'trend': 'up',
        'lastUpdated': DateTime.now().subtract(Duration(days: 2)),
        'communityPrice': 3.89
      },
      {
        'name': 'Bread',
        'price': 2.49,
        'trend': 'down',
        'lastUpdated': DateTime.now().subtract(Duration(days: 1)),
        'communityPrice': 2.59
      },
      {
        'name': 'Eggs',
        'price': 4.99,
        'trend': 'stable',
        'lastUpdated': DateTime.now().subtract(Duration(hours: 12)),
        'communityPrice': 4.99
      },
    ];

    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        final priceDifference =
            (item['price'] as double) - (item['communityPrice'] as double);
        final isPriceLower = priceDifference <= 0;

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text((item['name'] as String)[0],
                  style: TextStyle(color: Colors.white)),
            ),
            title: Text(item['name'] as String,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${item['price']}',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['trend'] == 'up'
                      ? Icons.trending_up
                      : item['trend'] == 'down'
                          ? Icons.trending_down
                          : Icons.trending_flat,
                  color: item['trend'] == 'up'
                      ? Colors.red
                      : item['trend'] == 'down'
                          ? Colors.green
                          : Colors.grey,
                ),
                Text(
                  item['trend'] == 'up'
                      ? 'Increased'
                      : item['trend'] == 'down'
                          ? 'Decreased'
                          : 'Stable',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Last updated: ${DateFormat.yMMMd().format(item['lastUpdated'] as DateTime)}'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Community price: \$${item['communityPrice']}'),
                        SizedBox(width: 8),
                        Text(
                          isPriceLower
                              ? 'You found a better deal!'
                              : 'Community found a better deal',
                          style: TextStyle(
                            color: isPriceLower ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                        'Price difference: ${priceDifference.abs().toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
