import 'package:flutter/material.dart';
import 'package:saveur/services/data_providers/local_recipe_provider.dart';
import 'package:saveur/models/recipe.dart';
import 'shopping_cart.dart';
import 'favorite_recipes_screen.dart';
import '../data/favorite_recipes_manager.dart';
import 'recipe_detail_screen.dart';
import 'diary_screen.dart';
import 'category_recipes_screen.dart'; // Asegúrate de importar la pantalla de categorías

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FavoriteRecipesManager _favoritesManager = FavoriteRecipesManager();
  List<Recipe> _localRecipes = [];
  bool _isLoadingLocal = true;
  List<Recipe> _favoriteRecipes = [];
  int _currentIndex = 0;
  String _searchQuery = '';
  List<String> _selectedIngredients = [];
  List<String> _ingredientSuggestions = [];
  TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = [
    // Puedes agregar más pantallas si lo deseas
    const ShoppingCart(),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocalRecipes();
    _loadFavoriteRecipes();
  }

  Future<void> _loadLocalRecipes() async {
    try {
      final recetas = await cargarRecetasLocales();
      setState(() {
        _localRecipes = recetas;
        _isLoadingLocal = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocal = false;
      });
      print('Error al cargar recetas locales: $e');
    }
  }

  Future<void> _loadFavoriteRecipes() async {
    final favoriteIds = await _favoritesManager.getFavoriteRecipeIds();
    setState(() {
      _favoriteRecipes = _localRecipes.where((r) => favoriteIds.contains(r.id)).toList();
    });
  }

  void _navigateToRecipeDetail(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreenLocal(recipe: recipe),
      ),
    );
  }

  List<String> _getIngredientSuggestions(String query) {
    if (query.isEmpty) return [];
    final allIngredients = _localRecipes.expand((r) => r.ingredients).toSet().toList();
    return allIngredients
        .where((ingredient) =>
            ingredient.toLowerCase().contains(query.toLowerCase()) &&
            !_selectedIngredients.contains(ingredient))
        .toList();
  }

  void _addIngredient(String ingredient) {
    setState(() {
      if (!_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.add(ingredient);
      }
      _searchQuery = '';
      _searchController.clear();
      _ingredientSuggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes = _localRecipes.where((recipe) {
      final matchesTitle = recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesIngredient = _selectedIngredients.isEmpty ||
          _selectedIngredients.every((ing) =>
              recipe.ingredients.any((rIng) => rIng.toLowerCase().contains(ing.toLowerCase())));
      // Si hay texto en el buscador, busca por título o ingrediente
      if (_searchQuery.isNotEmpty && _selectedIngredients.isEmpty) {
        return matchesTitle ||
            recipe.ingredients.any((ing) => ing.toLowerCase().contains(_searchQuery.toLowerCase()));
      }
      // Si hay ingredientes seleccionados, filtra por ellos
      return matchesIngredient;
    }).toList();

    final List<Map<String, dynamic>> categories = [
      {'name': 'Platillos', 'icon': Icons.restaurant, 'filter': 'platillo'},
      {'name': 'Desayunos', 'icon': Icons.free_breakfast, 'filter': 'desayuno'},
      {'name': 'Postres', 'icon': Icons.cake, 'filter': 'postre'},
      {'name': 'Sopas y caldos', 'icon': Icons.ramen_dining, 'filter': 'sopa'},
      {'name': 'Bebidas', 'icon': Icons.local_drink, 'filter': 'bebida'},
      {'name': 'Recetas rápidas', 'icon': Icons.flash_on, 'filter': 'rápida'},
      {'name': 'Mexicanas', 'icon': Icons.flag, 'filter': 'mexicana'},
      {'name': 'Vegetariano', 'icon': Icons.eco, 'filter': 'vegetariano'},
      {'name': 'Snacks', 'icon': Icons.fastfood, 'filter': 'snack'},
      {'name': 'Internacionales', 'icon': Icons.public, 'filter': 'internacional'},
    ];

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
          // IconButton(
          //   icon: const Icon(Icons.account_circle),
          //   onPressed: () => Navigator.pushNamed(context, '/account'),
          // ),
        ],
      ),
      body: _currentIndex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar receta o ingrediente...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _searchController.clear();
                                        _ingredientSuggestions = [];
                                        _selectedIngredients = [];
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _ingredientSuggestions = _getIngredientSuggestions(value);
                            });
                          },
                          onSubmitted: (value) {
                            if (_ingredientSuggestions.isNotEmpty && value.isNotEmpty) {
                              _addIngredient(_ingredientSuggestions.first);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _selectedIngredients
                              .map((ingredient) => Chip(
                                    label: Text(ingredient),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedIngredients.remove(ingredient);
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                        if (_ingredientSuggestions.isNotEmpty && _searchQuery.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: _ingredientSuggestions
                                .map((suggestion) => ActionChip(
                                      label: Text(suggestion),
                                      onPressed: () => _addIngredient(suggestion),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  if (_isLoadingLocal)
                    const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_localRecipes.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: _localRecipes.length,
                        controller: PageController(viewportFraction: 0.85),
                        itemBuilder: (context, index) {
                          final recipe = _localRecipes[index];
                          return GestureDetector(
                            onTap: () => _navigateToRecipeDetail(recipe),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (recipe.image.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.asset(
                                        recipe.image,
                                        width: double.infinity,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      recipe.title,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Categorías',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: categories.map((cat) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryRecipesScreen(
                                  categoryName: cat['name'],
                                  allRecipes: _localRecipes,
                                  filter: cat['filter'], // <-- Nuevo campo
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat['icon'], color: Theme.of(context).primaryColor),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  cat['name'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : _screens[_currentIndex],
    );
  }
}
