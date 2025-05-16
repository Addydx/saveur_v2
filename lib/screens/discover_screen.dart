import 'package:flutter/material.dart';

class DiscoverScreen  extends StatelessWidget{
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir'),
      ),
      body: const Center(
        child: Text('Pantalla de descubrir'),
      ),
    );
  }
}