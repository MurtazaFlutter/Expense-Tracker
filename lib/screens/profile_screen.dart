import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://placeholder.com/150'),
            ),
            SizedBox(height: 16),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            // TrustScoreBadge(score: 4.5),
            SizedBox(height: 24),
            _buildInfoCard('Email', 'john.doe@example.com'),
            _buildInfoCard('Location', 'New York, USA'),
            _buildInfoCard('Member Since', 'January 2023'),
            SizedBox(height: 24),
            _buildStatsRow(),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: () {
                // Navigate to edit profile screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Reviews', '42'),
        _buildStatItem('Helpful Votes', '128'),
        _buildStatItem('Following', '15'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
