import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityFeed extends ConsumerWidget {
  const CommunityFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement community feed provider
    final posts = [
      {'user': 'Alice', 'item': 'Milk', 'price': 3.99, 'location': 'SuperMart'},
      {
        'user': 'Bob',
        'item': 'Bread',
        'price': 2.49,
        'location': 'LocalBakery'
      },
      {
        'user': 'Charlie',
        'item': 'Eggs',
        'price': 4.99,
        'location': 'FarmFresh'
      },
    ];

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              child: Text((post['user'] as String)[0]),
            ),
            title: Text('${post['user']} found ${post['item']}'),
            subtitle: Text('Price: \$${post['price']} at ${post['location']}'),
            trailing: IconButton(
              icon: Icon(Icons.thumb_up),
              onPressed: () {
                // Implement like functionality
              },
            ),
          ),
        );
      },
    );
  }
}
