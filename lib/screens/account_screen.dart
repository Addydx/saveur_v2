//new screen acount
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushReplacementNamed(context, '/sign-in');
            });
          },
          child: const Text('Cerrar sesión'),
        ),
      ),
    );
  }
}