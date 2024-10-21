import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'meal_plan_service.dart';
import 'recipe_service.dart';
import 'recipe_detail_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final MealPlanService _mealPlanService = MealPlanService();
  final RecipeService _recipeService = RecipeService();
  late Future<List<dynamic>> _mealPlans;

  @override
  void initState() {
    super.initState();
    _mealPlans = _mealPlanService.getMealPlans();
  }

  void _addMealPlan(Map<String, dynamic> mealPlan) async {
    await _mealPlanService.saveMealPlan(mealPlan);
    setState(() {
      _mealPlans = _mealPlanService.getMealPlans();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal plan added!')),
    );
  }

  void _removeMealPlan(String mealPlanId) async {
    await _mealPlanService.removeMealPlan(mealPlanId);
    setState(() {
      _mealPlans = _mealPlanService.getMealPlans();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal plan removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final recipes = await _recipeService.getRecipes();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMealPlanScreen(
                    recipes: recipes,
                    addMealPlan: _addMealPlan,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _mealPlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final mealPlans = snapshot.data;
            if (mealPlans == null || mealPlans.isEmpty) {
              return const Center(child: Text('No meal plans found.'));
            }
            return ListView.builder(
              itemCount: mealPlans.length,
              itemBuilder: (context, index) {
                final mealPlan = mealPlans[index];
                return ListTile(
                  title: Text(mealPlan['title']),
                  leading: CachedNetworkImage(
                    imageUrl: mealPlan['image'],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeMealPlan(mealPlan['id']),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: mealPlan),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No meal plans found.'));
          }
        },
      ),
    );
  }
}

class AddMealPlanScreen extends StatelessWidget {
  final List<dynamic> recipes;
  final Function(Map<String, dynamic>) addMealPlan;

  const AddMealPlanScreen({super.key, required this.recipes, required this.addMealPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal Plan'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe['title']),
            leading: CachedNetworkImage(
              imageUrl: recipe['image'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            onTap: () {
              addMealPlan(recipe);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
