import 'package:flutter/material.dart';

class ShoppingCart extends StatelessWidget{
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
      ),
      body: const Center(
        child: Text('Pantall de compras'),
      ),
    );
  }
}