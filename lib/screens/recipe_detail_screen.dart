import 'package:flutter/material.dart';
import 'package:saveur/models/recipe.dart';

class RecipeDetailScreenLocal extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreenLocal({super.key, required this.recipe});

  @override
  State<RecipeDetailScreenLocal> createState() => _RecipeDetailScreenLocalState();
}

class _RecipeDetailScreenLocalState extends State<RecipeDetailScreenLocal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  recipe.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(Icons.star, color: Colors.amber, size: 28),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(text: 'Ingredientes'),
                      Tab(text: 'Pasos'),
                    ],
                  ),
                  // Mostrar ingredientes y pasos completos sin scroll interno
                  SizedBox(
                    height: null,
                    child: AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, _) {
                        if (_tabController.index == 0) {
                          // Ingredientes
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.ingredients
                                .map((ing) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                                      title: Text(ing),
                                    ))
                                .toList(),
                          );
                        } else {
                          // Pasos
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.steps
                                .asMap()
                                .entries
                                .map((entry) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white)),
                                      ),
                                      title: Text(entry.value),
                                    ))
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Tiempo: ${recipe.time}'),
                  Text('Dificultad: ${recipe.difficulty}'),
                  if (recipe.category.isNotEmpty) Text('Categoría: ${recipe.category}'),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Valoraciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No hay comentarios o reseñas.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text('Registrar comida'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/diary');
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}