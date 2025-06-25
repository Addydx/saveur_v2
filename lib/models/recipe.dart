import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String image;
  final String category;
  final String time;
  final String difficulty;
  final String servings;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.image,
    required this.category,
    required this.time,
    required this.difficulty,
    required this.servings,
  });

  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    String? image,
    String? category,
    String? time,
    String? difficulty,
    String? servings,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      image: image ?? this.image,
      category: category ?? this.category,
      time: time ?? this.time,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      image: json['image'],
      category: json['category'],
      time: json['time'],
      difficulty: json['difficulty'],
      servings: json['servings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'image': image,
      'category': category,
      'time': time,
      'difficulty': difficulty,
      'servings': servings,
    };
  }

  factory Recipe.fromRawJson(String str) => Recipe.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());
}
