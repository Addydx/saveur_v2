import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecipesManager {
  static const String _key = 'favorite_recipe_ids';

  Future<List<int>> getFavoriteRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
  }

  Future<void> addFavoriteRecipe(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getFavoriteRecipeIds();
    if (!ids.contains(id)) {
      ids.add(id);
      await prefs.setStringList(_key, ids.map((e) => e.toString()).toList());
    }
  }

  Future<void> removeFavoriteRecipe(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getFavoriteRecipeIds();
    ids.remove(id);
    await prefs.setStringList(_key, ids.map((e) => e.toString()).toList());
  }

  Future<bool> isRecipeFavorite(int id) async {
    final ids = await getFavoriteRecipeIds();
    return ids.contains(id);
  }
}