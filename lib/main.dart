import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'meal_plan_screen.dart';
import 'meal_planner_screen.dart';
import 'registration_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCZ1gJdsZBbPKDkqBQHi5ZrP_n-Y3BaBHU",
        authDomain: "recipebook-94d2b.firebaseapp.com",
        projectId: "recipebook-94d2b",
        storageBucket: "recipebook-94d2b.appspot.com",
        messagingSenderId: "786900677416",
        appId: "1:786900677416:web:c8798d253c674387e3961d",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personalized Recipe Book',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/mealPlan': (context) => const MealPlanScreen(),
        '/meal-planner': (context) => const MealPlannerScreen(),
      },
    );
  }
}
