import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About Electric Bill Optimizer',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent),
            ),
            SizedBox(height: 10),
            Text(
              'This app helps you track and optimize your electricity usage. Discover energy-saving tips and manage your appliances efficiently.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent),
            ),
            Text(
              '- Electricity usage tracking\n'
              '- Energy-saving tips\n'
              '- Appliance management\n'
              '- Cost breakdown for each appliance\n'
              '- Customizable notifications',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Developers:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent),
            ),
            Text(
              '1. Moeen Ahmed Butt\n'
              '2. Ahmad Waleed\n'
              '3. Muhammad Aman\n'
              '4. Muhammad Waqar Younas\n'
              '5. Umar Suhail',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent),
            ),
            Text(
              'Phone: 03149104427\nEmail: f2021266469@umt.edu.pk',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
