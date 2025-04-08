import 'package:flutter/material.dart';

class GuestModePage extends StatelessWidget {
  final List<Map<String, dynamic>> appliances = [
    {'name': 'Refrigerator', 'icon': Icons.kitchen},
    {'name': 'Air Conditioner', 'icon': Icons.ac_unit},
    {'name': 'Washing Machine', 'icon': Icons.local_laundry_service},
    {'name': 'Television', 'icon': Icons.tv},
    {'name': 'Oven', 'icon': Icons.microwave},
    {'name': 'Fan', 'icon': Icons.toys},
    {'name': 'Heater', 'icon': Icons.whatshot},
    {'name': 'Light Bulb', 'icon': Icons.lightbulb},
    {'name': 'Vacuum Cleaner', 'icon': Icons.cleaning_services},
    {'name': 'Coffee Maker', 'icon': Icons.coffee},
    {'name': 'Toaster', 'icon': Icons.bakery_dining},
    {'name': 'Iron', 'icon': Icons.iron},
    {'name': 'Water Heater', 'icon': Icons.water},
  ];

  void _showQuantityPopup(BuildContext context, String applianceName) {
    int quantity = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Set Quantity',
                style: TextStyle(color: Colors.tealAccent),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.tealAccent),
                    onPressed: () {
                      setState(() {
                        if (quantity > 0) quantity--;
                      });
                    },
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.tealAccent),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('You selected $quantity of $applianceName')),
                    );
                  },
                  child: Text('OK', style: TextStyle(color: Colors.tealAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Appliances'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.5,
          ),
          itemCount: appliances.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.tealAccent.withOpacity(0.1),
              child: InkWell(
                onTap: () {
                  _showQuantityPopup(context, appliances[index]['name']);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(appliances[index]['icon'],
                        size: 24, color: Colors.tealAccent),
                    SizedBox(height: 4),
                    Text(
                      appliances[index]['name'],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
