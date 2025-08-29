import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magus/features/authentication/auth_service.dart';

class LogRegPage extends StatefulWidget {
  const LogRegPage({super.key});

  @override
  LogRegPageState createState() => LogRegPageState();
}

class LogRegPageState extends State<LogRegPage> {
  // Widget properties
  final AuthService _auth = AuthService();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.88);

  String? _registerErrorMessage;

  void _showGoogleSignInError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  // Functions
  Future<void> _login() async {
    User? user = await _auth.signInWithEmailAndPassword(
      _loginEmailController.text,
      _loginPasswordController.text,
    );
    if (user != null) {
      // Navigate to home page
    }
  }

  Future<void> _register() async {
    setState(() {
      _registerErrorMessage = null;
    });
    try {
      User? user = await _auth.createUserWithEmailAndPassword(
        _registerEmailController.text,
        _registerPasswordController.text,
      );
      if (user != null) {
        // Navigate to home page
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _registerErrorMessage = _firebaseErrorToMessage(e);
      });
    } catch (e) {
      setState(() {
        _registerErrorMessage = 'An unknown error occurred. Please try again.';
      });
    }
  }

  String _firebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'Your password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              'Swipe to Login or Register',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: 2,
                    physics: BouncingScrollPhysics(), // Add this line
                    itemBuilder: (context, index) {
                      double currentPage = 0;
                      try {
                        currentPage =
                            _pageController.hasClients &&
                                _pageController.page != null
                            ? _pageController.page!
                            : _pageController.initialPage.toDouble();
                      } catch (_) {}
                      double scale = 1.0;
                      scale = 0.92 + (1 - (currentPage - index).abs()) * 0.08;
                      scale = scale.clamp(0.92, 1.0);
                      return Center(
                        child: Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            width: 400,
                            height: 520,
                            child: SingleChildScrollView(
                              child: index == 0
                                  ? _buildLoginContainer()
                                  : _buildRegisterContainer(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.login, size: 64, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Login',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          TextField(
            controller: _loginEmailController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: Colors.white),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _loginPasswordController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  // Google sign-in for web and mobile
                  _auth.signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.g_mobiledata,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Google',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              // TODO: Implement forgot password logic
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade300, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.app_registration, size: 64, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Register',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          if (_registerErrorMessage != null) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _registerErrorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          TextField(
            controller: _registerEmailController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: Colors.white),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _registerPasswordController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple.shade700,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              'Already Have Account?',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
