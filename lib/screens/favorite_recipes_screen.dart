// lib/screens/favorite_recipes_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_list_view.dart';
import 'favorite_recipes_screen.dart'; 
import '../data/favorite_recipes_manager.dart';
import 'recipe_detail_screen.dart';
class FavoriteRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes;

  const FavoriteRecipesScreen({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Recetas Favoritas')),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('No tienes recetas favoritas.'))
          : CustomListView(
              recipes: favoriteRecipes,
              favoriteRecipes: favoriteRecipes,
              showFavoriteIcon: true,
              onTap: (recipe) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                  ),
                );
                // Si quieres refrescar la lista aquí, deberías convertir este widget en StatefulWidget
              },
              onFavoriteTap: (recipe) async {
                // Aquí necesitas acceso al manager, puedes pasarlo como argumento o usar Provider
                await FavoriteRecipesManager().removeFavoriteRecipe(recipe['id']);
                // Si quieres refrescar la lista aquí, deberías convertir este widget en StatefulWidget
              },
            ),
    );
  }
}