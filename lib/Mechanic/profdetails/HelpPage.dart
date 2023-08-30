import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail(String emailAddress) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );

    final String emailLaunchUri = _emailLaunchUri.toString();

    if (await canLaunch(emailLaunchUri)) {
      await launch(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkTheme? Colors.amber.shade400 : Colors.blue,
        title: Text('Help'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Admin Contact'),
            subtitle: Text('+8801713772335'),
            onTap: () {
              _launchPhone(
                  '+8801713772335'); // Change the phone number to the one you want to call
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Admin Email'),
            subtitle: Text('shishirshohanuzzaman@gmail.com'),
            onTap: () {
              _launchEmail(
                  'shishirshohanuzzaman@gmail.com'); // Change the email address to the one you want to email
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Emergency Service'),
            subtitle: Text('+8801842014710'),
            onTap: () {
              _launchPhone(
                  '+8801842014710'); // Change the phone number to the one you want to call
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Emergency Service Email'),
            subtitle: Text('rahmanlabib74@gmail.com'),
            onTap: () {
              _launchEmail(
                  'rahmanlabib74@gmail.com'); // Change the email address to the one you want to email
            },
          ),
        ],
      ),
    );
  }
}
