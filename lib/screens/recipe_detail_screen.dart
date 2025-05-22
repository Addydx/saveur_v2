import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen de la receta'),
      ),
      body: Center(
        child: recipe['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
              )
            : const Text('No hay imagen disponible.'),
      ),
    );
  }
}