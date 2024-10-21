import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'recipe_detail_screen.dart';
import 'custom_recipe_card.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<dynamic>> _recipes;
  final Map<String, dynamic> _mealPlan = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  @override
  void initState() {
    super.initState();
    _recipes = _recipeService.getRecipes();
  }

  void _setMealForDay(String day, dynamic recipe) {
    setState(() {
      _mealPlan[day] = recipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _mealPlan.keys.map((day) {
            final meal = _mealPlan[day];
            return ListTile(
              title: Text(day),
              subtitle: meal != null
                  ? CustomRecipeCard(
                recipe: meal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: meal),
                    ),
                  );
                },
              )
                  : const Text('No meal planned'),
              trailing: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final selectedRecipe = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealSearchScreen(
                        day: day,
                        onRecipeSelected: (recipe) {
                          _setMealForDay(day, recipe);
                        },
                      ),
                    ),
                  );
                  if (selectedRecipe != null) {
                    _setMealForDay(day, selectedRecipe);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MealSearchScreen extends StatefulWidget {
  final String day;
  final Function(dynamic) onRecipeSelected;

  const MealSearchScreen({super.key, required this.day, required this.onRecipeSelected});

  @override
  _MealSearchScreenState createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  final RecipeService _recipeService = RecipeService();
  String query = '';
  Future<List<dynamic>>? _searchResults;

  void _search() {
    setState(() {
      _searchResults = _recipeService.searchRecipes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes for ${widget.day}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                query = value;
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final results = snapshot.data;
                    return ListView.builder(
                      itemCount: results?.length ?? 0,
                      itemBuilder: (context, index) {
                        final recipe = results?[index];
                        return CustomRecipeCard(
                          recipe: recipe,
                          onTap: () {
                            widget.onRecipeSelected(recipe);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No results found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
