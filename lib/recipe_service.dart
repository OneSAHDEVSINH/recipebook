//a017b0f5fd9e4b86a656c435d358b409
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeService {
  final String apiKey = 'a017b0f5fd9e4b86a656c435d358b409';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<dynamic>> getRecipes() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/random?number=10&apiKey=$apiKey&includeNutrition=true'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=$apiKey&includeNutrition=true'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  Future<void> saveFavoriteRecipe(Map<String, dynamic> recipe) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(recipe['id'].toString())
          .set(recipe);
    }
  }

  Future<void> removeFavoriteRecipe(String recipeId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(recipeId)
          .delete();
    }
  }

  Future<List<dynamic>> getFavoriteRecipes() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } else {
      return [];
    }
  }
}
