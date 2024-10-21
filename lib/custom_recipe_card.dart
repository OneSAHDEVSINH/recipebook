import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomRecipeCard extends StatelessWidget {
  final dynamic recipe;
  final VoidCallback onTap;

  const CustomRecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(recipe['title'], style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text('Ready in ${recipe['readyInMinutes']} minutes', style: Theme.of(context).textTheme.bodyMedium),
        leading: Hero(
          tag: 'recipeImage_${recipe['id']}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              imageUrl: recipe['image'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
