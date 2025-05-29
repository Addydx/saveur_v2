import 'package:flutter/material.dart';
import '../services/spoonacular_service.dart';
import 'recipe_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final SpoonacularService _service = SpoonacularService();

  String _searchQuery = '';
  String _sort = 'popularity';
  String? _type;
  String? _diet;
  int? _maxReadyTime;
  bool _isLoading = false;
  List<Map<String, dynamic>> _recipes = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final recipes = await _service.getRecipes(
        query: _searchQuery,
        sort: _sort,
        type: _type,
        diet: _diet,
        maxReadyTime: _maxReadyTime,
      );
      setState(() => _recipes = recipes);
    } catch (e) {
      setState(() => _error = 'Error al cargar recetas');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar receta o ingrediente...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _fetchRecipes();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtros con chips o dropdowns aquí
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('A-Z'),
                  selected: _sort == 'title',
                  onSelected: (_) {
                    setState(() => _sort = 'title');
                    _fetchRecipes();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Popular'),
                  selected: _sort == 'popularity',
                  onSelected: (_) {
                    setState(() => _sort = 'popularity');
                    _fetchRecipes();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Postre'),
                  selected: _type == 'dessert',
                  onSelected: (_) {
                    setState(() => _type = _type == 'dessert' ? null : 'dessert');
                    _fetchRecipes();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Vegano'),
                  selected: _diet == 'vegan',
                  onSelected: (_) {
                    setState(() => _diet = _diet == 'vegan' ? null : 'vegan');
                    _fetchRecipes();
                  },
                ),
                // Puedes agregar más filtros aquí
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _recipes.isEmpty
                        ? const Center(child: Text('No se encontraron recetas.'))
                        : ListView.builder(
                            itemCount: _recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = _recipes[index];
                              return ListTile(
                                leading: recipe['image'] != null
                                    ? Image.network(recipe['image'])
                                    : const Icon(Icons.image_not_supported),
                                title: Text(recipe['title']),
                                subtitle: Text(
                                  recipe['readyInMinutes'] != null
                                      ? 'Tiempo: ${recipe['readyInMinutes']} min'
                                      : '',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}