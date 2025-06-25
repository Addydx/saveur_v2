// lib/screens/favorite_recipes_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoriteRecipesScreen({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Recetas Favoritas')),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('No tienes recetas favoritas.'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return ListTile(
                  leading: recipe.image.isNotEmpty
                      ? Image.asset(recipe.image, width: 40, height: 40, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreenLocal(recipe: recipe),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      // Aquí deberías quitar de favoritos y refrescar la lista si lo deseas
                    },
                  ),
                );
              },
            ),
    );
  }
}