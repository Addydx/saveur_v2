import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:saveur/models/recipe.dart';

Future<List<Recipe>> cargarRecetasLocales() async {
  final String jsonString = await rootBundle.loadString('assets/data/recetas.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((json) => Recipe.fromJson(json)).toList();
}

/*
tejate 
limonada 
agua de naranja 
cafe con leche 

 */