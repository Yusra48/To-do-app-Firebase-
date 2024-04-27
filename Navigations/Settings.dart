import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.sort,
          color: Colors.grey,
        ),
        title: const Center(
          child: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://cdn.pixabay.com/photo/2018/08/03/12/18/wolf-3581809_640.jpg',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.brush, color: Colors.orange),
              title: const Text(
                'Change app color',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.text_increase, color: Colors.blue),
              title: const Text(
                'Change app Typography',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text(
                'Change App Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            const Text(
              'Import',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.grey),
              title: const Text(
                'Import from Google Calendar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
