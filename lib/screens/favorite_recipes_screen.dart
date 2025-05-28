import 'package:flutter/material.dart';
import '../widgets/custom_list_view.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes;
  final Function(Map<String, dynamic>) onTap;
  final Function(Map<String, dynamic>) onFavoriteTap;

  const FavoriteRecipesScreen({
    super.key,
    required this.favoriteRecipes,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Recetas Favoritas')),
      body: CustomListView(
        recipes: favoriteRecipes,
        favoriteRecipes: favoriteRecipes,
        showFavoriteIcon: true,
        onTap: onTap,
        onFavoriteTap: onFavoriteTap,
      ),
    );
  }
}