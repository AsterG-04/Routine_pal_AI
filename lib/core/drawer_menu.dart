import 'package:flutter/material.dart';
import 'package:magus/features/authentication/auth_service.dart';
import 'package:magus/core/utils.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text('AI'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ai);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Routine Management'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routineManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Graphs'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.graphs);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Reminders'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.reminders);
            },
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Routine Tracking'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routineTracking);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AuthService().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}