import 'package:flutter/material.dart';
import '../data/shopping_cart_manager.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final ShoppingCartManager _cartManager = ShoppingCartManager();
  List<Map<String, dynamic>> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final ingredients = await _cartManager.getIngredients();
    setState(() {
      _ingredients = ingredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de compras')),
      body: _ingredients.isEmpty
          ? const Center(child: Text('No hay ingredientes en el carrito.'))
          : ListView.builder(
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = _ingredients[index];
                final imageUrl = ingredient['image'] != null
                    ? 'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}'
                    : null;
                return ListTile(
                  leading: imageUrl != null
                      ? Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(ingredient['original'] ?? ingredient['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _cartManager.removeIngredient(ingredient['name']);
                      _loadIngredients();
                    },
                  ),
                );
              },
            ),
    );
  }
}