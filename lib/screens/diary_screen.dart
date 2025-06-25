import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final List<String> meals = ['Desayuno', 'Comida', 'Cena', 'Snack'];

  // Guarda los registros por comida
  final Map<String, Map<String, dynamic>> mealRecords = {};

  void _openRegisterDialog(String meal) async {
    final TextEditingController foodController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    int rating = 0;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registrar $meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: foodController,
                decoration: const InputDecoration(
                  labelText: '¿Qué comiste?',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Notas personales',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Calificación:'),
                  const SizedBox(width: 8),
                  ...List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        rating = index + 1;
                        (context as Element).markNeedsBuild();
                      },
                      child: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 22, // Más pequeño
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (foodController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'food': foodController.text,
                  'note': noteController.text,
                  'rating': rating,
                });
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        mealRecords[meal] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diario de comidas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: meals.map((meal) {
            final record = mealRecords[meal];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: Text(meal),
                subtitle: record == null
                    ? const Text('Sin registro')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comida: ${record['food']}'),
                          if ((record['note'] as String).isNotEmpty)
                            Text('Nota: ${record['note']}'),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < (record['rating'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                trailing: IconButton(
                  icon: Icon(record == null ? Icons.add : Icons.edit),
                  onPressed: () => _openRegisterDialog(meal),
                  tooltip: record == null ? 'Registrar' : 'Editar registro',
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}