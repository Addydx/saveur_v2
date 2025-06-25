import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  final List<String> meals = ['Desayuno', 'Comida', 'Cena'];

  // Estructura: {día: {momento: receta}}
  late Map<String, Map<String, String?>> weeklyMenu;

  @override
  void initState() {
    super.initState();
    _resetMenu();
  }

  void _resetMenu() {
    weeklyMenu = {
      for (var day in days)
        day: {for (var meal in meals) meal: null}
    };
    setState(() {});
  }

  void _addRecipe(String day, String meal) async {
    // Aquí puedes mostrar un modal o selector de recetas real
    // Por ahora, solo simula seleccionando una receta de ejemplo
    String? selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Selecciona una receta'),
        children: [
          SimpleDialogOption(
            child: const Text('Ejemplo: Chilaquiles'),
            onPressed: () => Navigator.pop(context, 'Chilaquiles'),
          ),
          SimpleDialogOption(
            child: const Text('Ejemplo: Tacos dorados'),
            onPressed: () => Navigator.pop(context, 'Tacos dorados'),
          ),
          SimpleDialogOption(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, null),
          ),
        ],
      ),
    );
    if (selected != null) {
      setState(() {
        weeklyMenu[day]![meal] = selected;
      });
    }
  }

  void _clearMenu() {
    _resetMenu();
  }

  void _generateRandomMenu() {
    // Aquí puedes implementar la lógica para sugerir recetas aleatorias
    // Por ahora, solo asigna "Receta aleatoria" a todos los bloques
    setState(() {
      for (var day in days) {
        for (var meal in meals) {
          weeklyMenu[day]![meal] = 'Receta aleatoria';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú semanal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpiar menú',
            onPressed: _clearMenu,
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Generar menú aleatorio',
            onPressed: _generateRandomMenu,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, dayIndex) {
          final day = days[dayIndex];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(),
                  ...meals.map((meal) {
                    final recipe = weeklyMenu[day]![meal];
                    return ListTile(
                      title: Text(meal),
                      subtitle: recipe != null
                          ? Text(recipe)
                          : const Text('Sin receta'),
                      trailing: ElevatedButton.icon(
                        icon: Icon(recipe == null ? Icons.add : Icons.edit),
                        label: Text(recipe == null ? 'Agregar' : 'Cambiar'),
                        onPressed: () => _addRecipe(day, meal),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}