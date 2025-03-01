import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://placeholder.com/150'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Doe',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('Verified Purchase',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                      5, (index) => Icon(Icons.star, color: Colors.amber)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Great product! Highly recommended.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.thumb_up),
                  label: Text('Helpful (24)'),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: Icon(Icons.comment),
                  label: Text('Comment (3)'),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
