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
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              else if(snapshot.hasData){
                final isNewUser = snapshot.data!;
                if(isNewUser){
                  return NewUserWelcomePage();
                } else {
                  return HomePage();
                }
              } else {
                return Scaffold(
                  body: Center(
                    child: Text('Unexpected state'),
                  ),
                );
              }
              }
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
