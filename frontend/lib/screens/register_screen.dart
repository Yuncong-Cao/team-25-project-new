// 用户注册页面，处理新用户注册

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                final emailError = Validators.validateEmail(email);
                final passwordError = Validators.validatePassword(password);

                if (emailError != null || passwordError != null) {
                  print('Email validation error: $emailError, Password validation error: $passwordError');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(emailError ?? passwordError!)),
                  );
                  return;
                }

                try {
                  await authProvider.register(email, password);
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed: $error')),
                  );
                }
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
