import 'package:flutter/material.dart';
import '../widgets/recipe_carousel_card.dart';
import '../services/spoonacular_service.dart';
import 'discover_screen.dart';
import 'search_screen.dart';
import 'shopping_cart.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import '../widgets/custom_list_view.dart';
import 'favorite_recipes_screen.dart'; // Importa tu manager
import '../data/favorite_recipes_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpoonacularService _spoonacularService = SpoonacularService();
  final FavoriteRecipesManager _favoritesManager = FavoriteRecipesManager();
  List<dynamic> _recipes = [];
  List<Map<String, dynamic>> _favoriteRecipes =
      []; // Lista para las recetas favoritas
  bool _isLoading = true;
  String? _errorMessage;

  int _currentIndex = 0; // Índice actual del BottomNavigationBar
  final List<Widget> _screens = [
    const DiscoverScreen(), // Pantalla de descubrir
    const SearchScreen(), // Pantalla de búsqueda
    const ShoppingCart(), // Pantalla del carrito
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _loadFavoriteRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await _spoonacularService.getPopularRecipes(number: 6);
      final favoriteIds = await _favoritesManager.getFavoriteRecipeIds();
      final favoriteRecipes =
          recipes
              .where((r) => favoriteIds.contains(r['id']))
              .map((r) => Map<String, dynamic>.from(r))
              .toList();

      if (mounted) {
        setState(() {
          _recipes = recipes;
          _favoriteRecipes = favoriteRecipes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar recetas. Intenta de nuevo.';
          _isLoading = false;
        });
      }
      print('Error al cargar recetas: $e'); // Depuración
    }
  }

  Future<void> _loadFavoriteRecipes() async {
    final favoriteIds = await _favoritesManager.getFavoriteRecipeIds();
    List<Map<String, dynamic>> favoriteRecipes = [];
    for (final id in favoriteIds) {
      final recipe = await _spoonacularService.getRecipeDetail(id);
      favoriteRecipes.add(recipe);
    }
    if (!mounted) return; // <--- Esto es clave
    setState(() {
      _favoriteRecipes = favoriteRecipes;
    });
  }

  void _navigateToRecipeDetail(int index) async {
    final recipeId = _recipes[index]['id'];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeId: recipeId),
      ),
    );
    _loadFavoriteRecipes(); // Refresca favoritos al volver
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saveur',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 2,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Color.fromARGB(66, 152, 238, 152),
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/account'),
          ),
        ],
      ),
      body:
          _currentIndex == 0
              ? Column(
                children: [
                  if (_isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadRecipes,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          RecipeCarouselCard(
                            recipes: _recipes,
                            onRecipeTap: _navigateToRecipeDetail,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = 1; // Cambia a DiscoverScreen
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Explorar más recetas'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Recetas favoritas',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                _favoriteRecipes.isEmpty
                                    ? const Center(child: Text('No tienes recetas favoritas.'))
                                    : CustomListView(
                                      recipes: [
                                        _favoriteRecipes.first,
                                      ], // Solo la primera receta favorita
                                      favoriteRecipes: _favoriteRecipes,
                                      showFavoriteIcon: true,
                                      onTap: (recipe) async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => RecipeDetailScreen(
                                                  recipeId: recipe['id'],
                                                ),
                                          ),
                                        );
                                        _loadFavoriteRecipes(); // Refresca favoritos al volver
                                      },
                                      onFavoriteTap: (recipe) async {
                                        await _favoritesManager
                                            .removeFavoriteRecipe(recipe['id']);
                                        _loadFavoriteRecipes(); // Refresca la lista
                                      },
                                    ),
                          ),
                          if (_favoriteRecipes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FavoriteRecipesScreen(favoriteRecipes: _favoriteRecipes),
                                    ),
                                  );
                                },
                                child: const Text('Ver todas las favoritas'),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              )
              : _screens[_currentIndex], // Cambia la pantalla según el índice,
    );
  }
}
