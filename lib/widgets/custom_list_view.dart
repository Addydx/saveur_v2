import 'package:flutter/material.dart';
import 'recipe_card.dart';

class CustomListView extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;
  final Function(Map<String, dynamic>) onTap;
  final bool showFavoriteIcon;
  final Function(Map<String, dynamic>)? onFavoriteTap;
  final List<Map<String, dynamic>>? favoriteRecipes;

  const CustomListView({
    super.key,
    required this.recipes,
    required this.onTap,
    this.showFavoriteIcon = false,
    this.onFavoriteTap,
    this.favoriteRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final isFavorite = favoriteRecipes?.any((r) => r['id'] == recipe['id']) ?? false;
        return Stack(
          children: [
            RecipeCard(
              title: recipe['title'] ?? 'Sin título',
              imageUrl: recipe['image'] ?? '',
              onTap: () => onTap(recipe),
            ),
            if (showFavoriteIcon)
              Positioned(
                top: 16,
                right: 32,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () => onFavoriteTap?.call(recipe),
                ),
              ),
          ],
        );
      },
    );
  }
}