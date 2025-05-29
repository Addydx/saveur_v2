// lib/managers/favorite_recipes_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecipesManager {
  static const String _favoritesKey = 'favoriteRecipeIds'; // Usaremos IDs para guardar

  // Carga los IDs de las recetas favoritas desde SharedPreferences
  Future<List<int>> getFavoriteRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null || favoritesJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> ids = json.decode(favoritesJson);
      return ids.cast<int>();
    } catch (e) {
      print('Error decoding favorite recipe IDs from SharedPreferences: $e');
      return []; // Retorna una lista vacía en caso de error de decodificación
    }
  }

  // Guarda la lista actual de IDs de recetas favoritas en SharedPreferences
  Future<void> _saveFavoriteRecipeIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(ids));
  }

  // Añade una receta a favoritos
  Future<void> addFavoriteRecipe(int recipeId) async {
    List<int> favorites = await getFavoriteRecipeIds();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await _saveFavoriteRecipeIds(favorites);
    }
  }

  // Elimina una receta de favoritos
  Future<void> removeFavoriteRecipe(int recipeId) async {
    List<int> favorites = await getFavoriteRecipeIds();
    favorites.remove(recipeId);
    await _saveFavoriteRecipeIds(favorites);
  }

  // Verifica si una receta es favorita
  Future<bool> isRecipeFavorite(int recipeId) async {
    List<int> favorites = await getFavoriteRecipeIds();
    return favorites.contains(recipeId);
  }

  
}