import 'package:flutter/material.dart';
import 'package:magus/features/authentication/database.dart';
import 'drawer_menu.dart'; // Import the drawer UI

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String username = 'Username';

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
        title: Text(username, textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to account settings
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(), // Add the drawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Page!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.database;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Database initialized!')),
                );
              },
              child: const Text('Create Database'),
            ),
          ],
        ),
      ),
    );
  }
}