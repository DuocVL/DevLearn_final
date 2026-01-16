import 'package:devlearn/widgets/bottom_nav_items.dart';
import 'package:devlearn/features/home/home_page.dart';
import 'package:devlearn/features/home/post_page.dart';
import 'package:devlearn/features/home/problem_page.dart';
import 'package:devlearn/features/home/profile_page.dart';
import 'package:devlearn/features/home/tutorial_page.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/routes/route_name.dart';
class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const TutorialPage(),
      const ProblemPage(),
      const PostPage(),
      ProfilePage(onLogout: widget.onLogout),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _selectedIndex == 3 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.createPost);
              },
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      // Nâng cấp BottomNavigationBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: AppBottomNavItems.items,
          type: BottomNavigationBarType.fixed, 
          backgroundColor: theme.scaffoldBackgroundColor, 
          selectedItemColor: theme.primaryColor, 
          unselectedItemColor: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600, 
          showSelectedLabels: false, 
          showUnselectedLabels: false,
          elevation: 0, 
        ),
      ),
    );
  }
}
