import 'package:flutter/material.dart';
import '../services/spoonacular_service.dart';
import 'package:saveur/screens/favorite_recipes_screen.dart'; // Importa tu manager
import '../data/favorite_recipes_manager.dart';
import '../data/shopping_cart_manager.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final SpoonacularService _service = SpoonacularService();
  final FavoriteRecipesManager _favoritesManager = FavoriteRecipesManager();
  final ShoppingCartManager _cartManager = ShoppingCartManager();
  Map<String, dynamic>? _recipeDetail;
  bool _isLoading = true;
  String? _error;
  bool _isFavorite = false;

  static const int maxFavorites = 20; // Límite de favoritos

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await _favoritesManager.isRecipeFavorite(widget.recipeId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    final ids = await _favoritesManager.getFavoriteRecipeIds();
    if (_isFavorite) {
      await _favoritesManager.removeFavoriteRecipe(widget.recipeId);
    } else {
      if (ids.length >= maxFavorites) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solo puedes guardar hasta 20 recetas favoritas.')),
        );
        return;
      }
      await _favoritesManager.addFavoriteRecipe(widget.recipeId);
    }
    _checkIfFavorite();
  }

  Future<void> _loadDetail() async {
    try {
      final detail = await _service.getRecipeDetail(widget.recipeId);
      setState(() {
        _recipeDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar detalles';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipeDetail?['title'] ?? 'Detalles de la receta'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_recipeDetail?['image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _recipeDetail!['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _recipeDetail?['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_recipeDetail?['summary'] != null)
                        Text(
                          // Limpia etiquetas HTML del summary
                          (_recipeDetail!['summary'] as String)
                              .replaceAll(RegExp(r'<[^>]*>'), ''),
                          style: const TextStyle(fontSize: 16),
                        ),
                      const SizedBox(height: 16),
                      if (_recipeDetail?['extendedIngredients'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingredientes:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recipeDetail!['extendedIngredients'].length,
                              itemBuilder: (context, index) {
                                final ingredient = _recipeDetail!['extendedIngredients'][index];
                                final imageUrl = ingredient['image'] != null
                                    ? 'https://spoonacular.com/cdn/ingredients_100x100/${ingredient['image']}'
                                    : null;
                                return ListTile(
                                  leading: imageUrl != null
                                      ? Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover)
                                      : const Icon(Icons.image_not_supported),
                                  title: Text(ingredient['original']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () async {
                                      await _cartManager.addIngredient(ingredient);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Ingrediente añadido al carrito')),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (_recipeDetail?['instructions'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instrucciones:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              (_recipeDetail!['instructions'] as String)
                                  .replaceAll(RegExp(r'<[^>]*>'), ''),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }
}