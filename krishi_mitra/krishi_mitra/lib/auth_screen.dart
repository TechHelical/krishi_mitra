import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; // Import your HomeScreen
import 'signup_screen.dart'; // Import the CongratulationsScreen

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUpVisible = true;
  final _signUpFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
  TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  String? _signUpErrorMessage;
  String? _loginErrorMessage;

  @override
  void dispose() {
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    if (_signUpFormKey.currentState!.validate()) {
      try {
        if (_signUpPasswordController.text ==
            _signUpConfirmPasswordController.text) {
          UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _signUpEmailController.text.trim(),
            password: _signUpPasswordController.text.trim(),
          );
          if (userCredential.user != null) {
            // Navigate to the Congratulations Screen on successful sign-up
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CongratulationsScreen()),
            );
          }
        } else {
          setState(() {
            _signUpErrorMessage = "Passwords do not match";
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _signUpErrorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _signUpErrorMessage = "An unexpected error occurred";
        });
      }
    }
  }

  Future<void> _loginWithEmailAndPassword() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmailController.text.trim(),
          password: _loginPasswordController.text.trim(),
        );
        if (userCredential.user != null) {
          // Navigate to the Home Screen on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _loginErrorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _loginErrorMessage = "An unexpected error occurred";
        });
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController _resetEmailController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: _resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send Reset Email'),
              onPressed: () async {
                if (_resetEmailController.text.isNotEmpty &&
                    _resetEmailController.text.contains('@')) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _resetEmailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent!'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Error sending reset email: ${e.message}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid email address')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E4),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title:
        const Text("Authentication", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                  _isSignUpVisible ? _buildSignUpForm() : _buildLoginForm(),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUpVisible = !_isSignUpVisible;
                      _signUpErrorMessage = null; // Clear any previous errors
                      _loginErrorMessage = null; // Clear any previous errors
                    });
                  },
                  child: Text(
                    _isSignUpVisible
                        ? "Already have an account? Log in"
                        : "Don't have an account? Sign up",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            "Create an account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _signUpEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email / Phone number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _signUpPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _signUpConfirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value != _signUpPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          if (_signUpErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                _signUpErrorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ElevatedButton(
            onPressed: _signUpWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
            const Text("Create account", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            "Login to account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email / Phone number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              child: const Text(
                "Forgot password?",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_loginErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                _loginErrorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ElevatedButton(
            onPressed: _loginWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Login now", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}