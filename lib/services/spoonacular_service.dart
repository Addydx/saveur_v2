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

  Future<Map<String, dynamic>> getSingleRecipe() async {
    final url = Uri.parse('$_baseUrl/recipes/random?number=1&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'] != null && data['recipes'].isNotEmpty
          ? data['recipes'][0] // Devuelve solo la primera receta
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
}