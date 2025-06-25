import 'package:flutter/material.dart';
import 'package:saveur/models/recipe.dart';
import 'package:saveur/screens/recipe_detail_screen.dart';

class CategoryRecipesScreen extends StatelessWidget {
  final String categoryName;
  final List<Recipe> allRecipes;
  final String filter;

  const CategoryRecipesScreen({
    super.key,
    required this.categoryName,
    required this.allRecipes,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = allRecipes.where((r) =>
      r.category.trim().toLowerCase() == filter.trim().toLowerCase()
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: filtered.isEmpty
          ? const Center(child: Text('No hay recetas en esta categoría.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final recipe = filtered[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreenLocal(recipe: recipe),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: recipe.image.isNotEmpty
                                ? Image.asset(
                                    recipe.image,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 48),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recipe.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}