//new screen acount
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  String _getAvatarLetter(User? user) {
    final name = user?.displayName?.trim();
    final email = user?.email?.trim();
    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    } else if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    } else {
      return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Text(
                      _getAvatarLetter(user),
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
              backgroundColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? user?.email ?? 'Usuario',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text('Mis recetas favoritas'),
            onTap: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.grey),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              // Lógica para cambiar contraseña
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Cerrar sesión'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              });
            },
          ),
        ],
      ),
    );
  }
}