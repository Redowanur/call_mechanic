import 'package:call_mechanic/WelcomePage.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomerPageUI();
  }
}

myAlertDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
            child: AlertDialog(
          title: Text('Alert !'),
          content: Text('Do you want to Log out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No')),
          ],
        ));
      });
}

class CustomerPageUI extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                // decoration: BoxDecoration(color: Colors.cyan),
                accountName: Text('Redowanur Rahman'),
                accountEmail: Text('rahmanlabibn74@gmail.com'),
                currentAccountPicture: Image.network(
                    'https://pluspng.com/img-png/user-png-icon-download-icons-logos-emojis-users-2240.png'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                // mySnackBar('Home', context);
              },
            ),
            ListTile(
              title: Text('Contact'),
              leading: Icon(Icons.contact_mail),
              onTap: () {
                // mySnackBar('Contact', context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                // mySnackBar('Profile', context);
              },
            ),
            ListTile(
              title: Text('Locate Mechanic'),
              leading: Icon(Icons.location_on),
              onTap: () {
                // mySnackBar('Email', context);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout),
              onTap: () {
                myAlertDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    flex: 80,
                    child: Image.asset('images/banner.png'),
                  ),
                  Expanded(
                    flex: 20,
                    child: Text(
                      'Need A Mechanic?',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
