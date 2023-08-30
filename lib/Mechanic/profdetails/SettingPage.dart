import 'package:flutter/material.dart';

import '../../../forgot_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ListTile(
            //   title: Text('Notifications'),
            //   subtitle: Text('Enable or disable notifications'),
            //   trailing: Switch(
            //     value: notificationsEnabled,
            //     onChanged: (value) {
            //       setState(() {
            //         notificationsEnabled = value;
            //       });
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: Text('Dark Mode'),
            //   subtitle: Text('Switch between light and dark mode'),
            //   trailing: Switch(
            //     value: darkModeEnabled,
            //     onChanged: (value) {
            //       setState(() {
            //         darkModeEnabled = value;
            //       });
            //     },
            //   ),
            // ),
            ListTile(
              title: Text('Change Password'),
              subtitle: Text('Change your account password'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => ForgotPassword()));
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              subtitle: Text('View our privacy policy'),
              onTap: () {
                // Add functionality to open privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }
}
