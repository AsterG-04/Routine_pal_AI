import 'package:flutter/material.dart';
import 'package:magus/features/authentication/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}