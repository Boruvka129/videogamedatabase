import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamedatabaseapp/pages/main_page.dart';
import 'package:gamedatabaseapp/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  final _auth = FirebaseAuth.instance;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); 

    if (isValid) {
      _formKey.currentState!.save();

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        print('User signed in successfully');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.message}');
        setState(() {
          _errorMessage = 'You are entering wrong password or email'; 
        });
      }
    }
  }

  void _handleForgotPassword(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text('Reset Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text('Enter your registered email address'),
                 SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:  InputDecoration(hintText: 'Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    try {
                      await _auth.sendPasswordResetEmail(
                          email: _emailController.text.trim());
                      Navigator.of(context).pop(); 
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Password reset email sent. Check your inbox.'),
                      ));
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${e.message}'),
                      ));
                    }
                  },
                  child: Text('Send Email')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key:  ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  decoration:  InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: true,
                  decoration:  InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0), 
                Text(
                  _errorMessage,
                  style:  TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _trySubmit,
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    _handleForgotPassword(context);
                  }, 
                  child: Text('Forgot Password?', style: TextStyle(fontSize: 14.0)),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  RegisterPage()),
                        );
                      },
                      child: const Text('Register'),
                    ),
              ],
            ),
            ]
          ),
        ),
      ),
    )
    );
  }
} 
