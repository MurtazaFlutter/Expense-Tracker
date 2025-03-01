import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingItem('Change Password', Icons.lock, () {}),
              _buildSettingItem('Privacy', Icons.privacy_tip, () {}),
              _buildSettingItem('Notifications', Icons.notifications, () {}),
            ],
          ),
          _buildSection(
            'App Settings',
            [
              _buildSettingItem('Language', Icons.language, () {}),
              _buildSettingItem('Dark Mode', Icons.dark_mode, () {}),
              _buildSettingItem('Accessibility', Icons.accessibility, () {}),
            ],
          ),
          _buildSection(
            'Support',
            [
              _buildSettingItem('Help Center', Icons.help, () {}),
              _buildSettingItem('Contact Us', Icons.mail, () {}),
              _buildSettingItem('Terms of Service', Icons.description, () {}),
              _buildSettingItem('Privacy Policy', Icons.policy, () {}),
            ],
          ),
          _buildSection(
            'Account Actions',
            [
              _buildSettingItem('Delete Account', Icons.delete_forever, () {},
                  color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items,
        Divider(),
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
