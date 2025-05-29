// lib/services/spoonacular_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  static const String _apiKey = 'a99522d6b0404ae1b3aa7e2c2ff674b3';
  static const String _baseUrl = 'https://api.spoonacular.com';

  Future<List<dynamic>> getPopularRecipes({int number = 5}) async {
    final url = Uri.parse('$_baseUrl/recipes/random?number=$number&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'] ?? [];
    } else {
      throw Exception('Error al obtener recetas: ${response.statusCode}');
    }
  }

  // Este método getSingleRecipe parece redundante si ya tienes getPopularRecipes(number:1) y getRecipeDetail(id)
  // Considera si realmente lo necesitas o si puedes eliminarlo.
  Future<Map<String, dynamic>> getSingleRecipe() async {
    final url = Uri.parse('$_baseUrl/recipes/random?number=1&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'] != null && data['recipes'].isNotEmpty
          ? data['recipes'][0]
          : {};
    } else {
      throw Exception('Error al obtener la receta: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getRecipeDetail(int id) async {
    final url = Uri.parse('$_baseUrl/recipes/$id/information?includeNutrition=false&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener detalles de la receta: ${response.statusCode}');
    }
  }

  // --- NUEVO MÉTODO para obtener detalles de múltiples recetas por sus IDs ---
  Future<List<Map<String, dynamic>>> getRecipesInformationBulk(List<int> recipeIds) async {
    if (recipeIds.isEmpty) {
      return [];
    }
    final String idsString = recipeIds.join(','); // Convierte la lista de IDs a una cadena separada por comas
    final url = Uri.parse('$_baseUrl/recipes/informationBulk?apiKey=$_apiKey&ids=$idsString');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>(); // La API devuelve una lista de objetos de receta
      } else {
        print('Error al obtener detalles en bulk: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load recipes in bulk: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error loading recipes in bulk: $e');
      throw Exception('Network error loading recipes in bulk');
    }
  }
}