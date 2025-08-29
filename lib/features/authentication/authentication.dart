import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magus/core/home.dart';
import 'package:magus/features/authentication/auth_service.dart';
import 'package:magus/features/authentication/pages/loading.dart';
import 'package:magus/features/authentication/pages/login-register.dart';
import 'package:magus/features/authentication/pages/newUser.dart';

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LogRegPage();
          } else {
            return FutureBuilder<bool>(
              future: AuthService().isNewUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final isNewUser = snapshot.data ?? false;
                  if (isNewUser) {
                    return HomePage();
                  } else {
                    return NewUserWelcomePage();
                  }
                }
                return CircularProgressIndicator();
              },
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
