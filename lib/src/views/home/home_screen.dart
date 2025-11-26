import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/utils/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('School Management'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      drawer: isWideScreen ? null : _buildDrawer(context),
      body: isWideScreen
          ? Row(
              children: [
                _buildPermanentDrawer(context),
                Expanded(child: child),
              ],
            )
          : child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: _buildDrawerContent(context),
    );
  }

  Widget _buildPermanentDrawer(BuildContext context) {
    return Drawer(
      elevation: 1.0,
      child: _buildDrawerContent(context),
    );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Dashboard'),
          onTap: () {
            context.go('/dashboard');
            _closeDrawerIfNecessary(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Students'),
          onTap: () {
            context.go('/students');
            _closeDrawerIfNecessary(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.school),
          title: const Text('Teachers'),
          onTap: () {
            context.go('/teachers');
            _closeDrawerIfNecessary(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Fees'),
          onTap: () {
            context.go('/fees');
            _closeDrawerIfNecessary(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Attendance'),
          onTap: () {
            context.go('/attendance');
            _closeDrawerIfNecessary(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.grading),
          title: const Text('Grades'),
          onTap: () {
            context.go('/grades');
            _closeDrawerIfNecessary(context);
          },
        ),
      ],
    );
  }

  void _closeDrawerIfNecessary(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    if (!isWideScreen) {
      Navigator.of(context).pop();
    }
  }
}
