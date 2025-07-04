// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GuestModePage extends StatelessWidget {
  final List<Map<String, dynamic>> appliances = [
    {'name': 'refrigerator', 'icon': Icons.kitchen},
    {'name': 'air_conditioner', 'icon': Icons.ac_unit},
    {'name': 'washing_machine', 'icon': Icons.local_laundry_service},
    {'name': 'television', 'icon': Icons.tv},
    {'name': 'oven', 'icon': Icons.microwave},
    {'name': 'fan', 'icon': Icons.toys},
    {'name': 'heater', 'icon': Icons.whatshot},
    {'name': 'light_bulb', 'icon': Icons.lightbulb},
    {'name': 'vacuum_cleaner', 'icon': Icons.cleaning_services},
    {'name': 'coffee_maker', 'icon': Icons.coffee},
    {'name': 'toaster', 'icon': Icons.bakery_dining},
    {'name': 'iron', 'icon': Icons.iron},
    {'name': 'water_heater', 'icon': Icons.water},
  ];

  void _showQuantityPopup(BuildContext context, String applianceKey) {
    int quantity = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'set_quantity'.tr(),
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
                  child:
                      Text('cancel'.tr(), style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'selected_quantity'.tr(namedArgs: {
                            'quantity': '$quantity',
                            'appliance': applianceKey.tr()
                          }),
                        ),
                      ),
                    );
                  },
                  child: Text('ok'.tr(),
                      style: TextStyle(color: Colors.tealAccent)),
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
        title: Text('select_appliances'.tr()),
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
                  _showQuantityPopup(
                      context, appliances[index]['name'] as String);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(appliances[index]['icon'],
                        size: 24, color: Colors.tealAccent),
                    SizedBox(height: 4),
                    Text(
                      (appliances[index]['name'] as String).tr(),
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
