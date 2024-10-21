import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'recipe_detail_screen.dart';
import 'custom_recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<dynamic>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = _recipeService.getFavoriteRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final favorites = snapshot.data;
            if (favorites == null || favorites.isEmpty) {
              return const Center(child: Text('No favorite recipes found.'));
            }
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return CustomRecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No favorite recipes found.'));
          }
        },
      ),
    );
  }
}
