import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShoppingCartManager {
  static const String _key = 'shopping_cart_ingredients';

  Future<List<Map<String, dynamic>>> getIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => Map<String, dynamic>.from(json.decode(e))).toList();
  }

  Future<void> addIngredient(Map<String, dynamic> ingredient) async {
    final prefs = await SharedPreferences.getInstance();
    final ingredients = await getIngredients();
    ingredients.add(ingredient);
    await prefs.setStringList(_key, ingredients.map((e) => json.encode(e)).toList());
  }

  Future<void> removeIngredient(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final ingredients = await getIngredients();
    ingredients.removeWhere((e) => e['name'] == name);
    await prefs.setStringList(_key, ingredients.map((e) => json.encode(e)).toList());
  }
}