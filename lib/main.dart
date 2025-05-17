import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'screens/records_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RegistroScreen(),
    AddExpenseScreen(onExpenseAdded: () {}),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
