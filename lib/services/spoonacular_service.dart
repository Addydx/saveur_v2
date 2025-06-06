// lib/services/spoonacular_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  static const String _apiKey = '510c6c25c84b42dea9497040df7d6d50';
  //proximo api key 2746c96e76d44abe8bf08595e8a5e08a
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

  Future<List<Map<String, dynamic>>> getRecipes({
    String? query,
    String? sort,
    String? type,
    String? diet,
    int? maxReadyTime,
  }) async {
    final Map<String, String> params = {
      'apiKey': _apiKey,
      'number': '20',
      if (query != null && query.isNotEmpty) 'query': query,
      if (sort != null) 'sort': sort,
      if (type != null && type.isNotEmpty) 'type': type,
      if (diet != null && diet.isNotEmpty) 'diet': diet,
      if (maxReadyTime != null) 'maxReadyTime': maxReadyTime.toString(),
    };

    final uri = Uri.https(
      'api.spoonacular.com',
      '/recipes/complexSearch',
      params,
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Error al cargar recetas');
    }
  }
}