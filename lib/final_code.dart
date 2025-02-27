// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use, prefer_const_constructors_in_immutables

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Utils/void main() {.dart';

void main() {
  runApp(ElectricBillApp());
}

class ElectricBillApp extends StatefulWidget {
  const ElectricBillApp({super.key});

  @override
  _ElectricBillAppState createState() => _ElectricBillAppState();
}

class _ElectricBillAppState extends State<ElectricBillApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WelcomePage(
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const WelcomePage(
      {super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedElectricityIcon(),
            SizedBox(height: 20),
            Text(
              'Electric Bill Optimizer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigationPage(
                      onThemeToggle: onThemeToggle,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Let's Start",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedElectricityIcon extends StatefulWidget {
  const AnimatedElectricityIcon({super.key});

  @override
  _AnimatedElectricityIconState createState() =>
      _AnimatedElectricityIconState();
}

class _AnimatedElectricityIconState extends State<AnimatedElectricityIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(Icons.bolt, size: 150, color: Colors.tealAccent),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MainNavigationPage(
      {super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDarkMode', isDarkMode));
  }
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Initialize the screens list inside the build method
    final List<Widget> screens = [
      HomeScreen(),
      ProfileScreen(),
      SettingsScreen(
        onThemeToggle: (isDark) {
          widget.onThemeToggle(); // Access widget here
        },
        isDarkMode: widget.isDarkMode, onLanguageChange: (String ) {  }, selectedLanguage: '', // Access widget here
      ),
      AboutScreen(),
      AddBillScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Add Bill',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bolt, size: 100, color: Colors.tealAccent),
            SizedBox(height: 20),
            Text(
              'Welcome to Electric Bill Optimizer!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? UserProfile(
            onLogout: () {
              setState(() {
                isLoggedIn = false;
              });
            },
          )
        : LoginForm(
            onLogin: () {
              setState(() {
                isLoggedIn = true;
              });
            },
            onGuestMode: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuestModePage()),
              );
            },
          );
  }
}
class LoginForm extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onGuestMode;

  const LoginForm({super.key, required this.onLogin, required this.onGuestMode});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? loggedInUser;

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorPopup("Kindly enter username and password to log in.");
    } else {
      setState(() {
        loggedInUser = username;
      });
      widget.onLogin();
    }
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error", style: TextStyle(color: Colors.redAccent)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK", style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                loggedInUser != null ? "Welcome, $loggedInUser!" : "Welcome Back!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email or Username',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.email, color: Colors.tealAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.lock, color: Colors.tealAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: widget.onGuestMode,
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class GuestModePage extends StatefulWidget {
  @override
  _GuestModePageState createState() => _GuestModePageState();
}

class _GuestModePageState extends State<GuestModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Mode'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: appliances.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.tealAccent.withOpacity(0.1),
              child: InkWell(
                onTap: () {
                  _showApplianceTypePopup(context, appliances[index]['name'], appliances[index]['types']);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(appliances[index]['icon'], size: 50, color: Colors.tealAccent),
                    SizedBox(height: 10),
                    Text(
                      appliances[index]['name'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
  TextEditingController wattageController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> selectedAppliances = [];

  @override
  void dispose() {
    _focusNode.dispose();
    wattageController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> appliances = [
    {'name': 'Light Bulb', 'icon': Icons.lightbulb, 'types': ['LED', 'CFL', 'Incandescent']},
    {'name': 'Television', 'icon': Icons.tv, 'types': ['LED', 'LCD', 'OLED']},
    {'name': 'Refrigerator', 'icon': Icons.kitchen, 'types': ['Single Door', 'Double Door', 'Side by Side']},
    {'name': 'Air Conditioner', 'icon': Icons.ac_unit, 'types': ['Window', 'Split', 'Portable']},
    {'name': 'Washing Machine', 'icon': Icons.local_laundry_service, 'types': ['Front Load', 'Top Load', 'Semi Automatic']},
    {'name': 'Oven', 'icon': Icons.microwave, 'types': ['Microwave', 'Convection', 'Grill']},
    {'name': 'Fan', 'icon': Icons.toys, 'types': ['Ceiling', 'Table', 'Wall']},
    {'name': 'Heater', 'icon': Icons.whatshot, 'types': ['Electric', 'Gas']},
    {'name': 'Vacuum Cleaner', 'icon': Icons.cleaning_services, 'types': ['Handheld', 'Canister', 'Robot']},
    {'name': 'Coffee Maker', 'icon': Icons.coffee, 'types': ['Drip', 'Espresso', 'French Press']},
    {'name': 'Toaster', 'icon': Icons.bakery_dining, 'types': ['2 Slice', '4 Slice', 'Oven Toaster']},
    {'name': 'Iron', 'icon': Icons.iron, 'types': ['Steam', 'Dry', 'Cordless']},

  ];

  void _showApplianceTypePopup(BuildContext context, String applianceName, List<String> types) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Select Type of $applianceName', style: TextStyle(color: Colors.tealAccent)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: types.map((type) {
              return ListTile(
                title: Text(type, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showWattagePopup(context, applianceName, type);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showWattagePopup(BuildContext context, String applianceName, String type) {
    wattageController.clear();
    _focusNode.requestFocus();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Enter Wattage for $applianceName ($type)', style: TextStyle(color: Colors.tealAccent)),
          content: TextField(
            controller: wattageController,
            focusNode: _focusNode,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter watts',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _focusNode.unfocus();
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _focusNode.unfocus();
                String enteredWattage = wattageController.text;
                Navigator.pop(context);
                _showQuantityPopup(context, applianceName, type, enteredWattage);
              },
              child: Text('OK', style: TextStyle(color: Colors.tealAccent)),
            ),
          ],
        );
      },
    );
  }

  void _showQuantityPopup(BuildContext context, String applianceName, String type, String wattage) {
    int quantity = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text('Set Quantity for $applianceName ($type - $wattage W)', style: TextStyle(color: Colors.tealAccent)),
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
                  Text('$quantity', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                    setState(() {
                      selectedAppliances.add({
                        'name': applianceName,
                        'type': type,
                        'wattage': wattage,
                        'quantity': quantity,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $quantity x $applianceName ($type) - $wattage W'),
                      ),
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
}


class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;
  final String selectedLanguage;
  final Function(String) onLanguageChange;

  const SettingsScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeState;
  bool notificationsEnabled = true;

  _SettingsScreenState() : isDarkModeState = false;

  @override
  void initState() {
    super.initState();
    isDarkModeState = widget.isDarkMode;
  }

  void _selectLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  widget.onLanguageChange('English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Urdu'),
                onTap: () {
                  widget.onLanguageChange('Urdu');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Arabic'),
                onTap: () {
                  widget.onLanguageChange('Arabic');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang = widget.selectedLanguage;
    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'Urdu' ? 'ترتیبات' : lang == 'Arabic' ? 'الإعدادات' : 'Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text(lang == 'Urdu' ? 'ڈارک موڈ' : lang == 'Arabic' ? 'الوضع الداكن' : 'Dark Mode'),
            value: isDarkModeState,
            onChanged: (value) {
              setState(() {
                isDarkModeState = value;
              });
              widget.onThemeToggle(value);
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.tealAccent),
            title: Text(lang == 'Urdu' ? 'زبان' : lang == 'Arabic' ? 'اللغة' : 'Language'),
            subtitle: Text(lang),
            onTap: () {
              _selectLanguage(context);
            },
          ),
          SwitchListTile(
            title: Text(lang == 'Urdu' ? 'اطلاعات' : lang == 'Arabic' ? 'الإشعارات' : 'Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value ? (lang == 'Urdu' ? 'اطلاعات فعال ہوگئی ہیں' : lang == 'Arabic' ? 'تم تفعيل الإشعارات' : 'Notifications are ON') : (lang == 'Urdu' ? 'اطلاعات بند ہوگئی ہیں' : lang == 'Arabic' ? 'تم إيقاف الإشعارات' : 'Notifications are OFF'))),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description, color: Colors.tealAccent),
            title: Text(lang == 'Urdu' ? 'شرائط و ضوابط' : lang == 'Arabic' ? 'الشروط والأحكام' : 'Terms & Conditions'),
            subtitle: Text(lang == 'Urdu' ? 'ایپ کے قواعد پڑھیں' : lang == 'Arabic' ? 'اقرأ قواعد التطبيق' : 'Read our terms and conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsConditionsScreen(lang: lang)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  final String lang;
  const TermsConditionsScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lang == 'Urdu' ? 'شرائط و ضوابط' : lang == 'Arabic' ? 'الشروط والأحكام' : 'Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          lang == 'Urdu' ? 'اس ایپ کو استعمال کرتے ہوئے، آپ ہماری شرائط و ضوابط سے اتفاق کرتے ہیں۔ بجلی کے استعمال کی مؤثر نگرانی کے لیے ذمہ داری سے ایپ کا استعمال یقینی بنائیں۔' :
          lang == 'Arabic' ? 'باستخدام هذا التطبيق، فإنك توافق على شروطنا وأحكامنا. تأكد من الاستخدام المسؤول للتطبيق لمراقبة استهلاك الكهرباء بشكل فعال.' :
          'By using this app, you agree to our terms and conditions. Ensure responsible usage of the application for monitoring electricity consumption effectively.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

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

class AddBillScreen extends StatefulWidget {
  AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;
  String extractedText = "No text detected yet.";
  bool _isProcessing = false;

  Future<void> _showImagePicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery Picker'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Use Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = imageBytes;
        });
        await _processImageForOCR(pickedFile as File);
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<void> _processImageForOCR(File imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final GoogleVisionImage visionImage =
          GoogleVisionImage.fromFile(File(imageFile.path));
      final TextRecognizer textRecognizer =
          GoogleVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      setState(() {
        extractedText = (visionText.text!.isNotEmpty
            ? visionText.text
            : "No text found in the image.")!;
      });

      textRecognizer.close();
    } catch (e) {
      setState(() {
        extractedText = "Error processing image: $e";
      });
      print("Error during OCR process: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bill with OCR'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageData != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.memory(
                    _imageData!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Text(
                  'No image selected',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showImagePicker(context),
                child: Text('Upload Bill Image'),
              ),
              SizedBox(height: 20),
              if (_isProcessing)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    Text(
                      "Extracted Text:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        extractedText,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
