import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:share_plus/share_plus.dart';  // Import share package
import 'recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final dynamic recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<bool> _internetConnection;
  final RecipeService _recipeService = RecipeService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _internetConnection = checkInternetConnection();
    _checkIfFavorite();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _checkIfFavorite() async {
    final favorites = await _recipeService.getFavoriteRecipes();
    setState(() {
      isFavorite = favorites.any((recipe) => recipe['id'] == widget.recipe['id']);
    });
  }

  void _toggleFavorite() async {
    try {
      if (isFavorite) {
        await _recipeService.removeFavoriteRecipe(widget.recipe['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe removed from favorites')),
        );
      } else {
        await _recipeService.saveFavoriteRecipe(widget.recipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe saved to favorites')),
        );
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  // Share recipe details function
  void _shareRecipe() {
    final title = widget.recipe['title'] ?? 'Recipe';
    final description = widget.recipe['instructions'] ?? 'No instructions provided.';
    final recipeUrl = widget.recipe['sourceUrl'] ?? '';  // Assuming you have a source URL

    Share.share('$title\n\n$description\n\nCheck out the recipe here: $recipeUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['title'] ?? 'Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRecipe,  // Share button for sharing recipe
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: _internetConnection,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == false) {
            return const Center(child: Text('No internet connection.'));
          } else {
            final ingredients = widget.recipe['extendedIngredients'] ?? [];
            final nutrition = widget.recipe['nutrition']?['nutrients'] ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'recipeImage_${widget.recipe['id']}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.recipe['image'],
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          // Custom configurations for better caching
                          cacheKey: widget.recipe['id'].toString(),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 300),
                          maxHeightDiskCache: 800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.recipe['title'] ?? 'No title available',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Ready in ${widget.recipe['readyInMinutes']?.toString() ?? 'N/A'} minutes',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const Text(
                      'Ingredients:',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    for (var ingredient in ingredients)
                      Text(
                        ingredient['original'] ?? 'No ingredient info',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const Text(
                      'Nutritional Information:',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    for (var nutrient in nutrition)
                      Text(
                        '${nutrient['name'] ?? 'N/A'}: ${nutrient['amount']?.toString() ?? 'N/A'} ${nutrient['unit'] ?? ''}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const Text(
                      'Instructions:',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.recipe['instructions'] ?? 'No instructions provided.',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
