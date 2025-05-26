import 'package:flutter/material.dart';
import '../widgets/recipe_carousel_card.dart';
import '../services/spoonacular_service.dart';
import 'discover_screen.dart';
import 'search_screen.dart';
import 'shopping_cart.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpoonacularService _spoonacularService = SpoonacularService();
  List<dynamic> _recipes = [];
  bool _isLoading = true;
  String? _errorMessage;

  int _currentIndex = 0; // Índice actual del BottomNavigationBar
  final List<Widget> _screens = [
    const HomeScreen(), // Pantalla principal
    const DiscoverScreen(), // Pantalla de descubrir
    const SearchScreen(), // Pantalla de búsqueda
    const ShoppingCart(), // Pantalla del carrito
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await _spoonacularService.getPopularRecipes(number: 5);
      if (mounted) {
        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
        print('Recetas cargadas: $_recipes'); // Depuración
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

  void _navigateToRecipeDetail(int index) {
    final recipeId = _recipes[index]['id'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeId: recipeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saveur',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 2,
            shadows: [
              Shadow(
          blurRadius: 4,
          color: Colors.black26,
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
                                  _currentIndex =
                                      1; // Cambia a la pantalla DiscoverScreen
                                });
                                // Acción para explorar más recetas
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Explorar más recetas'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              )
              : _screens[_currentIndex], // Cambia la pantalla según el índice,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Descubrir',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
      ),
    );
  }
}



