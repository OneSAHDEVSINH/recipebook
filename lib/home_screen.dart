import 'package:flutter/material.dart';
import 'custom_recipe_card.dart';
import 'recipe_service.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<dynamic>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = _recipeService.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.hd),
            onPressed: () {
              Navigator.pushNamed(context, '/mealPlan');
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/meal-planner');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _recipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final recipes = snapshot.data;
              return ListView.builder(
                itemCount: recipes?.length ?? 0,
                itemBuilder: (context, index) {
                  final recipe = recipes?[index];
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
              return const Center(child: Text('No recipes found.'));
            }
          },
        ),
      ),
    );
  }
}


//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<dynamic>>(
//           future: _recipes,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               final recipes = snapshot.data;
//               return ListView.builder(
//                 itemCount: recipes?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final recipe = recipes?[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     elevation: 5,
//                     margin: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16.0),
//                       title: Text(recipe['title'], style: Theme.of(context).textTheme.bodyLarge),
//                       subtitle: Text('Ready in ${recipe['readyInMinutes']} minutes', style: Theme.of(context).textTheme.bodyMedium),
//                       leading: Hero(
//                         tag: 'recipeImage_${recipe['id']}',
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15.0),
//                           child: CachedNetworkImage(
//                             imageUrl: recipe['image'],
//                             placeholder: (context, url) => CircularProgressIndicator(),
//                             errorWidget: (context, url, error) => Icon(Icons.error),
//                           ),
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RecipeDetailScreen(recipe: recipe),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text('No recipes found.'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

